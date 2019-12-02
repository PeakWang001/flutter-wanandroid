import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/model/system_entity.dart';
import 'package:flutter_app2/page/list_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SystemDetailPage extends StatefulWidget {

  SystemEntity systemEntity;
  int index = 0;

  SystemDetailPage(this.systemEntity, this.index);

  @override
  _SystemDetailPageState createState() => _SystemDetailPageState();
}

class _SystemDetailPageState extends State<SystemDetailPage> with SingleTickerProviderStateMixin{

  List<Tab> tabs = [];
  TabController mTabController;
  PageController mPageController;
  bool isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i< widget.systemEntity.children.length;i++){
        tabs.add(Tab(text: widget.systemEntity.children[i].name,));
    }
    //initialIndex初始选中第几个
    mPageController = new PageController(initialPage: widget.index);
    mTabController =
        TabController(initialIndex: widget.index, length: tabs.length, vsync: this);
    mTabController.addListener(() {
      if (mTabController.indexIsChanging) {
        //判断TabBar是否切换
        onPageChange(mTabController.index, p: mPageController);
      }
    });
  }
  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      //判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageView切换完毕,再释放pageView监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //切换TabBar
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.systemEntity.name,
          style: TextStyle(
            fontSize: ScreenUtil.getInstance().setWidth(45),
            color: Colors.white
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child:Center(
            child:  Image.asset(
              'assets/img/ic_back.png',
              width: ScreenUtil.getInstance().setWidth(45),
              height: ScreenUtil.getInstance().setWidth(45),
              fit: BoxFit.fill,
            ),
          ),
        ),
        bottom: TabBar(
          tabs: tabs,
          controller: mTabController,
          isScrollable: true,
          indicatorColor: Colors.yellow,
          indicatorWeight: 5,//指示器宽度
          indicatorSize: TabBarIndicatorSize.label,  //指示器显示长度  根据文字大小 label  根据tab大小 tab
          indicatorPadding: EdgeInsets.only(bottom: 10.0), //指示器padding
          labelPadding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
          labelColor: Colors.white, //选中文字颜色
          labelStyle: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(45),//选中文字大小
          ),
          unselectedLabelColor: Color(0x90ffffff),//未选中文字颜色
          unselectedLabelStyle: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(45),//未选中文字大小
          ),
        ),
      ),
      body: PageView.builder(
          itemCount: tabs.length,
          itemBuilder: (BuildContext context, int index){
            return ListItemPage(widget.systemEntity.children[index].id,Api.ARTICLE_LIST,isProject: false,);
          },
        onPageChanged: (index) {
          if (isPageCanChanged) {
            //由于pageView切换是会回调这个方法,又会触发切换tabBar的操作,所以定义一个flag,控制pageView的回调
            onPageChange(index);
          }
        },
        controller: mPageController,),
    );
  }
}
