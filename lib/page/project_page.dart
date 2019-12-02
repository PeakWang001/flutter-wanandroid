
import 'dart:convert';

import "package:flutter/material.dart" show BuildContext, Container, State, StatefulWidget, Widget;
import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/model/project_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'list_item.dart';

///项目Page
class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> with SingleTickerProviderStateMixin{
  TabController mTabController;
  List<ProjectEntity> projectList = [];
  int index = 0;
  var mPageController = new PageController(initialPage: 0);
  var isPageCanChanged = true;
  bool isShowFloatBtn = false;

  @override
  void initState() {
    super.initState();
    loadProjectList();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: projectList.length==0
        ?Text('加载中...')
        :TabBar(
          tabs: getTabs(),
          controller: mTabController,
          isScrollable: true,
          indicatorColor: Colors.yellow,
          indicatorWeight: 5,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.only(bottom: 10.0),
          labelPadding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(45),
          ),
          unselectedLabelColor: Color(0x90ffffff),
          unselectedLabelStyle: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(45),
          ),
        ),

      ),
      body: PageView.builder(
        onPageChanged: (index){
          if(isPageCanChanged) onPageChange(index);},
          itemBuilder: (BuildContext context, index){
            return ListItemPage(projectList[index].id,Api.PROJECT_LIST,isProject: true);
          },
          controller: mPageController,
          itemCount: projectList.length,
          ),
    );
  }


  List<Tab> getTabs() {
    List<Tab> temps = [];
    for (var i = 0; i < projectList.length; i++) {
      temps.add(Tab(
        text: projectList[i].name,
      ));
    }
    return temps;
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      //判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //切换Tabbar
    }
  }

  //加载文章列表
  void loadProjectList() async{
    HttpUtils.getInstance().get(Api.PROJECT,successCallBack: (data){
      List responseJson = json.decode(data);
      setState(() {
        projectList = responseJson.map((json) => ProjectEntity.fromJson(json)).toList();
        //initialIndex初始选中第几个
        mTabController =
            TabController(initialIndex: 0, length: projectList.length, vsync: this);
        mTabController.addListener(() {
          if (mTabController.indexIsChanging) {
            //判断TabBar是否切换
            onPageChange(mTabController.index, p: mPageController);
          }
        });
      });
    });

  }

}


