import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/model/wechat_list_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/webview_page.dart';
import 'package:flutter_app2/utils/utils.dart';
import 'package:flutter_app2/widget/toast.dart';
import 'package:flutter_app2/widget/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeChatListPage extends StatefulWidget {
  int _id;

  WeChatListPage(this._id);

  @override
  _WeChatListPageState createState() => _WeChatListPageState();
}

class _WeChatListPageState extends State<WeChatListPage> with AutomaticKeepAliveClientMixin{
  int currentPage = 0;
  List<WeChatListEntity> weChatList = [];
  //页面加载状态，默认为加载中
  LoadState _loadState = LoadState.loading;
  bool isShowFloatBtn = false;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    loadWeChatListData();
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
      body: StateView(
          _loadState,
          onTap: (){
            loadWeChatListData();
            setState(() {
              _loadState = LoadState.loading;
            });
          },
          successWidget: EasyRefresh(
            child: ListView.builder(
              controller: _controller,
                itemCount: weChatList.length,
                itemBuilder: (BuildContext context, index) {
                  return _itemRow(context, index);
                }),
            onRefresh: () async {
              weChatList.clear();
              currentPage = 0;
              loadWeChatListData();
            },
            onLoad: () async {
              currentPage++;
              loadWeChatListData();
            },
          )
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

  void loadWeChatListData() {
    HttpUtils.getInstance()
        .get('${Api.WXARTICLE_LIST}${widget._id}/$currentPage/json',
            successCallBack: (data) {
      Map<String, dynamic> dataJson = json.decode(data);
      List responseJson = json.decode(json.encode(dataJson['datas']));
      List<WeChatListEntity> responseList =
          responseJson.map((json) => WeChatListEntity.fromJson(json)).toList();
      if(mounted){
        setState(() {
          weChatList.addAll(responseList);
          _loadState = Utils.getLoadStatus(weChatList);
        });
      }
    },errorCallBack: (){
          _loadState = LoadState.error;
        }
    );
  }

  _itemRow(context, index) {
    var weChat = weChatList[index];
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return WebViewPage(
              url: weChat.link,
              title: weChat.title,
              id: weChat.id,
            );
          }));
        },
        child: Container(
          margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Container(),
                  ),
                  Text(
                    weChat.niceDate,
                  ),
                ],
              ),
              Divider(
                height: ScreenUtil.getInstance().setHeight(20),
                color: Colors.transparent,
              ),
              Container(
                height: ScreenUtil.getInstance().setHeight(100),
                child: Text(weChat.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(40),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                      '公众号 ● ${weChat.chapterName}'
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  GestureDetector(
                    child: Image(
                        width: ScreenUtil.getInstance().setWidth(60),
                        height: ScreenUtil.getInstance().setWidth(60),
                        image: weChat.collect == false
                            ? AssetImage('assets/img/collect_1.png')
                            : AssetImage('assets/img/collect_2.png')),
                    onTap: (){
                      HttpUtils.getInstance().post(
                          weChat.collect == false
                              ?'${Api.COLLECT}${weChat.id}/json'
                              :'${Api.UN_COLLECT_ORIGIN_ID}${weChat.id}/json',
                          successCallBack: (data){
                            setState(() {
                              weChat.collect = !weChat.collect;
                            });
                          },
                          errorCallBack: (code,msg){
                            T.showToast(msg);
                          }
                      );
                    },
                  ),
                ],
              ),
              Divider(
                height: ScreenUtil.getInstance().setHeight(20),
                color: Colors.transparent,
              ),
              Divider(
                height: ScreenUtil.getInstance().setHeight(8),
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
