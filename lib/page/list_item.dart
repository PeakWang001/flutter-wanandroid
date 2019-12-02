import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/model/article_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/webview_page.dart';
import 'package:flutter_app2/utils/utils.dart';
import 'package:flutter_app2/widget/toast.dart';
import 'package:flutter_app2/widget/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//通用列表widget
class ListItemPage extends StatefulWidget {
  int _id;
  bool isProject = false;
  String _url;

  ListItemPage(this._id, this._url, {this.isProject});

  @override
  _ListItemPageState createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage>
    with AutomaticKeepAliveClientMixin {
  int currentPage = 0;
  List<ArticleEntity> articleList = [];
  //页面加载状态，默认为加载中
  LoadState _loadState = LoadState.loading;
  bool isShowFloatBtn = false;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    loadArticleData();
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
            loadArticleData();
            setState(() {
              _loadState = LoadState.loading;
            });
          },
          successWidget: EasyRefresh(
            child: ListView.builder(
                controller: _controller,
                itemCount: articleList.length,
                itemBuilder: (BuildContext context, index) {
                  return widget.isProject
                      ? _projectItemRow(context, index)
                      : _itemRow(context, index);
                }),
            onRefresh: () async {
              articleList.clear();
              currentPage = 0;
              loadArticleData();
            },
            onLoad: () async {
              currentPage++;
              loadArticleData();
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
  void loadArticleData() {
    var params = {"cid": widget._id};
    HttpUtils.getInstance().get('${widget._url}$currentPage/json',
        params: params, successCallBack: (data) {
      Map<String, dynamic> dataJson = json.decode(data);
      List responseJson = json.decode(json.encode(dataJson['datas']));
      List<ArticleEntity> responseList =
          responseJson.map((json) => ArticleEntity.fromJson(json)).toList();
      if(mounted){
        setState(() {
          articleList.addAll(responseList);
          _loadState = Utils.getLoadStatus(articleList);
        });
      }
    },errorCallBack: (){
          _loadState = LoadState.error;
        });
  }

  _itemRow(context, index) {
    ArticleEntity article = articleList[index];
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return WebViewPage(
                url: article.link,
                title: article.title,
                id: article.id,
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
                      article.niceDate,
                    ),
                  ],
                ),
                Divider(
                  height: ScreenUtil.getInstance().setHeight(20),
                  color: Colors.transparent,
                ),
                Container(
                  height: ScreenUtil.getInstance().setHeight(100),
                  child: Text(
                    article.title,
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
                        '${article.superChapterName} ● ${article.chapterName}'),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    GestureDetector(
                      child: Image(
                          width: ScreenUtil.getInstance().setWidth(60),
                          height: ScreenUtil.getInstance().setWidth(60),
                          image: article.collect == false
                              ? AssetImage('assets/img/collect_1.png')
                              : AssetImage('assets/img/collect_2.png')),
                      onTap: () {
                        HttpUtils.getInstance().post(
                            article.collect == false
                                ? '${Api.COLLECT}${article.id}/json'
                                : '${Api.UN_COLLECT_ORIGIN_ID}${article.id}/json',
                            successCallBack: (data) {
                          setState(() {
                            article.collect = !article.collect;
                          });
                        }, errorCallBack: (code, msg) {
                          T.showToast(msg);
                        });
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
          )),
    );
  }

  ///项目itemList
  _projectItemRow(context, index) {
    var article = articleList[index];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: ScreenUtil.getInstance().setHeight(430),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return WebViewPage(
              url: article.link,
              title: article.title,
              id: article.id,
            );
          }));
        },
        child: new Container(
            margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                "" != article.envelopePic
                    ? CachedNetworkImage(
                        fit: BoxFit.fill,
                        width: ScreenUtil.getInstance().setHeight(200),
                        height: ScreenUtil.getInstance().setHeight(350),
                        imageUrl: article.envelopePic,
                        placeholder: (context, url) => ProgressView(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )
                    : new Container(),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().setWidth(40),
                        right: ScreenUtil.getInstance().setWidth(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      //Main 轴大小，可选值有：
                      //MainAxisSize.max：相当于 Android 的 match_parent
                      //MainAxisSize.min：相当于 Android 的 wrap_content
//                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          '' != article.author
                              ? article.author
                              : article.shareUser,
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Divider(
                          height: ScreenUtil.getInstance().setHeight(20),
                          color: Colors.transparent,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              article.superChapterName,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil.getInstance().setSp(30),
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
                              article.chapterName,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil.getInstance().setSp(30),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: ScreenUtil.getInstance().setHeight(30),
                          color: Colors.transparent,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(article.title,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Divider(
                          height: ScreenUtil.getInstance().setHeight(20),
                          color: Colors.transparent,
                        ),
                        Text(
                          article.niceDate,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Image(
                      width: ScreenUtil.getInstance().setWidth(60),
                      height: ScreenUtil.getInstance().setWidth(60),
                      image: article.collect == false
                          ? AssetImage('assets/img/collect_1.png')
                          : AssetImage('assets/img/collect_2.png')),
                  onTap: () {
                    HttpUtils.getInstance().post(
                        article.collect == false
                            ? '${Api.COLLECT}${article.id}/json'
                            : '${Api.UN_COLLECT_ORIGIN_ID}${article.id}/json',
                        successCallBack: (data) {
                          setState(() {
                            article.collect = !article.collect;
                          });
                        }, errorCallBack: (code, msg) {
                      T.showToast(msg);
                    });
                  },
                ),
              ],
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
