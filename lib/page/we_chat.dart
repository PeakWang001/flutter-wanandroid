import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/model/wechat_chapters_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/we_chat_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeChatPage extends StatefulWidget {
  @override
  _WeChatPageState createState() => _WeChatPageState();
}

class _WeChatPageState extends State<WeChatPage> with SingleTickerProviderStateMixin{
  List<WeChatChapterEntity> mWeChatChapterList = [];
  TabController mTabController;
  int index = 0;
  var mPageController = new PageController(initialPage: 0);
  var isPageCanChanged = true;
  var currentPage = 0;
  @override
  void initState() {
    super.initState();
    loadWeChatChapterList();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: mWeChatChapterList.length == 0
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
          return WeChatListPage(mWeChatChapterList[index].id);
          },
        controller: mPageController,
        itemCount: mWeChatChapterList.length
      ),
    );
  }

  getTabs() {
    List<Tab> temps = [];
    for (var i = 0; i < mWeChatChapterList.length; i++) {
      temps.add(Tab(
        text: mWeChatChapterList[i].name,
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
          curve: Curves.ease); //等待pageView切换完毕,再释放pageiVew监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //切换Tabbar
    }
  }


  //加载公众号列表
  void loadWeChatChapterList() async{
    HttpUtils.getInstance().get(Api.WXARTICLE_CHAPTERS,successCallBack: (data){
      List responseJson = json.decode(data);
      setState(() {
        mWeChatChapterList = responseJson.map((json) => WeChatChapterEntity.fromJson(json)).toList();
        //initialIndex初始选中第几个
        mTabController =
            TabController(initialIndex: 0, length: mWeChatChapterList.length, vsync: this);
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



