import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/model/system_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/system_detail.dart';
import 'package:flutter_app2/utils/utils.dart';
import 'package:flutter_app2/widget/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SystemPage extends StatefulWidget {
  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> with AutomaticKeepAliveClientMixin{
  List<SystemEntity> list = [];
  //页面加载状态，默认为加载中
  LoadState _loadState = LoadState.loading;
  ScrollController _controller;
  bool isShowFloatBtn = false;

  @override
  void initState() {
    super.initState();
    loadSystemData();
    _controller = new ScrollController();
    _controller.addListener(() {
      int offset = _controller.offset.toInt();
      if (offset < 480 && isShowFloatBtn) {
        isShowFloatBtn = false;
        setState(() {});
      } else if (offset > 480 && !isShowFloatBtn) {
        isShowFloatBtn = true;
        setState(() {});
      }
    });
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
          '体系',
          style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(45)),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: StateView(
        _loadState,
        onTap: (){
          loadSystemData();
          setState(() {
            _loadState = LoadState.loading;
          });
        },
        successWidget: ListView.builder(
          controller: _controller,
          itemBuilder: (BuildContext context, index) {
            return _itemRow(context, index);
          },
          itemCount: list.length,
        ),
      ),
     floatingActionButton: _floatingActionButton(),


    );
  }
  _floatingActionButton() {
    return isShowFloatBtn
        ? FloatingActionButton(
        child: Icon(
          Icons.keyboard_arrow_up,
        ),
        onPressed: () {
          _controller.animateTo(0.0,
              duration: new Duration(milliseconds: 300),
              curve: Curves.linear);
        })
        :null;
  }
  _itemRow(context, index) {
    var entity = list[index];

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        left: ScreenUtil.getInstance().setWidth(45),
        top: ScreenUtil.getInstance().setWidth(45),
        right: ScreenUtil.getInstance().setWidth(45),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            entity.name,
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil.getInstance().setSp(40)),
          ),
          Divider(
            height: ScreenUtil.getInstance().setHeight(20),
            color: Colors.transparent,
          ),
          Wrap(
            /**
             * 这里区分一下主轴和纵轴的概念：
             * 当水平方向的时候，其主轴就是水平，纵轴就是垂直。
             * 当垂直方向的时候，其主轴就是垂直，纵轴就是水平。
             *
             */
            direction: Axis.horizontal,
            //不设置默认为horizontal
            alignment: WrapAlignment.start,
            //沿主轴方向居中
            spacing: 10.0,
            //主轴（水平）方向间距
            runSpacing: 10.0,
            //纵轴（垂直）方向间距
            children: getChild(entity),
          ),
        ],
      ),
    );
  }

  void loadSystemData() {
    HttpUtils.getInstance().get(Api.TREE, successCallBack: (data) {
      List responseJson = json.decode(data);
      setState(() {
        list = responseJson.map((json) => SystemEntity.fromJson(json)).toList();
        _loadState = Utils.getLoadStatus(list);
      });
    },errorCallBack:(code,msg){
      _loadState = LoadState.error;
    }
    );
  }

  getChild(SystemEntity entity) {
    List<Widget> child = [];
    for (int i = 0; i < entity.children.length; i++) {
      Children children = entity.children[i];
      child.add(InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new SystemDetailPage( entity,i );
          }));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().setWidth(40),
              ScreenUtil.getInstance().setWidth(20),
              ScreenUtil.getInstance().setWidth(40),
              ScreenUtil.getInstance().setWidth(20)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 1),
            color: Color(0xFFf5f5f5),
            borderRadius:
                BorderRadius.circular(ScreenUtil.getInstance().setWidth(40)),
          ),
          child: Text(
              children.name,
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(36),
                color: const Color(0xFF999999)),
          ),
        ),
      ));
    }
    return child;
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
