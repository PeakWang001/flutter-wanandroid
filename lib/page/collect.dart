import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/model/collect_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/webview_page.dart';
import 'package:flutter_app2/utils/utils.dart';
import 'package:flutter_app2/widget/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/widgets.dart';
///我的收藏
class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  List<CollectEntity> list = [];
  int currentPage = 0;
  //页面加载状态，默认为加载中
  LoadState _loadState = LoadState.loading;

  @override
  void initState() {
    super.initState();
    loadCollectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff4282f4),
          title: Text(
            '收藏',
            style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(45),
                color: Colors.white),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child:Center(
              child:  Image.asset(
                'assets/img/ic_back.png',
                width: ScreenUtil.getInstance().setWidth(45),
                height: ScreenUtil.getInstance().setWidth(45),
                fit: BoxFit.fill,
              ),
            )
          ),
        ),
        body: StateView(
          _loadState,
          onTap: () {
            loadCollectData();
            setState(() {
              _loadState = LoadState.loading;
            });
          },
          successWidget: EasyRefresh(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _itemRow(context, index);
              },
              itemCount: list.length,
            ),
            onRefresh: () async {
              list.clear();
              currentPage = 0;
              loadCollectData();
            },
            onLoad: () async {
              currentPage++;
              loadCollectData();
            },
          ),));
  }

  _itemRow(BuildContext context, int index) {
    CollectEntity entity = list[index];
    return Container(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return WebViewPage(
                url: entity.link,
                title: entity.title,
                id: entity.id,
              );
            }));
          },
          child: Container(
            margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      entity.author,
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(35),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' | ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ScreenUtil.getInstance().setSp(30),
                      ),
                    ),
                    Text(
                      entity.chapterName,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ScreenUtil.getInstance().setSp(30),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    GestureDetector(
                      child: Image(
                          width: ScreenUtil.getInstance().setWidth(60),
                          height: ScreenUtil.getInstance().setWidth(60),
                          image: AssetImage('assets/img/collect_2.png')),
                      onTap: () {
                        HttpUtils.getInstance().post(
                            '${Api.UN_COLLECT_ORIGIN_ID}${entity.originId}/json',
                            successCallBack: (data) {
                          setState(() {
                            list.removeAt(index);
                            if(list.length==0){
                              _loadState = LoadState.empty;
                            }
                          });
                        });
                      },
                    ),
                  ],
                ),
                Divider(
                  height: ScreenUtil.getInstance().setHeight(20),
                  color: Colors.transparent,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: ScreenUtil.getInstance().setHeight(100),
                        child: Text(entity.title,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
//
                    ),
                    "" != entity.envelopePic
                        ? CachedNetworkImage(
                            fit: BoxFit.fill,
                            width: ScreenUtil.getInstance().setHeight(250),
                            height: ScreenUtil.getInstance().setHeight(250),
                            imageUrl: entity.envelopePic,
                            placeholder: (context, url) => ProgressView(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          )
                        : new Container()
                  ],
                ),
                Divider(
                  height: ScreenUtil.getInstance().setHeight(20),
                  color: Colors.transparent,
                ),
                Row(
                  children: <Widget>[Text(entity.niceDate)],
                ),
                Divider(
                  height: ScreenUtil.getInstance().setHeight(10),
                  color: Colors.transparent,
                ),
                Divider(
                  height: ScreenUtil.getInstance().setHeight(2),
                ),
              ],
            ),
          ),
        ));
  }

  void loadCollectData() {
    HttpUtils.getInstance().get('${Api.COLLECT_LIST}$currentPage/json',
        successCallBack: (data) {
      Map<String, dynamic> dataMap = json.decode(data);
      List responseJson = json.decode(json.encode(dataMap['datas']));
      List<CollectEntity> responseList =
          responseJson.map((json) => CollectEntity.fromJson(json)).toList();
      setState(() {
        list.addAll(responseList);
        _loadState = Utils.getLoadStatus( list);
      });
    },errorCallBack: (code,msg){
       setState(() {
         _loadState = LoadState.error;
       });
    });
  }
}
