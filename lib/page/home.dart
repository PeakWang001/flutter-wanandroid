import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/event/login_event.dart';
import 'package:flutter_app2/model/banner_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/webview_page.dart';
import 'package:flutter_app2/utils/utils.dart';
import 'package:flutter_app2/widget/toast.dart';
import 'package:flutter_app2/widget/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../model/article_entity.dart';
import '../main.dart';
///首页
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeStatePage();
}

class HomeStatePage extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int currentPage = 0; //第一页
  SwiperController _swiperController;
  ScrollController _controller;
  List<BannerEntity> bannerList = []; //BannerList
  List<ArticleEntity> articleList = []; //ArticleTopList
  //页面加载状态，默认为加载中
  LoadState _loadState = LoadState.loading;
  bool isShowFloatBtn = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<LoginEvent>().listen((event) {
        loadArticleTop();
    });
    //获取Banner数据
    getBanner();
    loadArticleTop();
    _swiperController = new SwiperController();
    _swiperController.startAutoplay();
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
    _swiperController.stopAutoplay();
    _swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '首页',
            style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(45)),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: StateView(
          _loadState,
          onTap: () {
            articleList.clear();
            currentPage = 0;
            loadArticleTop();
            setState(() {
              _loadState = LoadState.loading;
            });
          },
          successWidget: EasyRefresh(
            child: ListView.builder(
                controller: _controller,
                itemCount: articleList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _itemBanner(context, index);
                  } else {
                    return _itemRow(context, index - 1);
                  }
                }),
            onRefresh: () async {
              articleList.clear();
              currentPage = 0;
              loadArticleTop();
            },
            onLoad: () async {
              currentPage++;
              loadArticleData();
            },
          ),
        ),
        floatingActionButton: _floatingActionButton()
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

  ///Banner
  _itemBanner(context, index) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: ScreenUtil.getInstance().setWidth(600),
      child: Swiper(
        //Banner
        itemBuilder: (context, index) {
//          return Image.network(bannerList[index].imagePath);
          return CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: bannerList[index].imagePath,
            placeholder: (context, url) => ProgressView(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          );
        },
        itemCount: bannerList.length,
        loop: false,
        // 无限轮播模式开关
        index: 0,
        //初始的时候下标位置
        autoplay: true,
        //是否自动播放
        autoplayDelay: 3000,
        //自动播放延迟毫秒数.默认 3000
        autoplayDisableOnInteraction: true,
        //当用户拖拽的时候，是否停止自动播放.
        duration: 300,
        //过场时间.默认300
        controller: _swiperController,
        //控制器(SwiperController)
        pagination: SwiperPagination(
          //展示默认分页指示器
            builder: DotSwiperPaginationBuilder(
                color: Colors.white, activeColor: Colors.blue)),
        control: SwiperControl(),
        //展示默认分页按钮
        scrollDirection: Axis.horizontal,
        onTap: (index) {
          //点击事件
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new WebViewPage(
              url: bannerList[index].url,
              title: bannerList[index].title,
              id: bannerList[index].id,
            );
          }));
        },
      ),
    );
  }

  ///listView item
  _itemRow(context, index) {
    var article = articleList[index];
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
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
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new ClipOval(
                            //圆形Image
                            child: Image(
                                width: ScreenUtil.getInstance().setWidth(80),
                                height: ScreenUtil.getInstance().setWidth(80),
                                image: AssetImage('assets/img/portrait.png')),
                          ),
                          Container(
                            width: ScreenUtil.getInstance().setWidth(30),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Row(
                                children: <Widget>[
                                  Text(
                                    article.superChapterName,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                      ScreenUtil.getInstance().setSp(30),
                                    ),
                                  ),
                                  Text(
                                    ' | ',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                      ScreenUtil.getInstance().setSp(30),
                                    ),
                                  ),
                                  Text(
                                    article.chapterName,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                      ScreenUtil.getInstance().setSp(30),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
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
                                      : '${Api.UN_COLLECT_ORIGIN_ID}${article
                                      .id}/json',
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: ScreenUtil.getInstance().setHeight(100),
                              child: Text(article.title,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
//
                          ),
                          "" != article.envelopePic
                              ? CachedNetworkImage(
                            fit: BoxFit.fill,
                            width:
                            ScreenUtil.getInstance().setHeight(250),
                            height:
                            ScreenUtil.getInstance().setHeight(250),
                            imageUrl: article.envelopePic,
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
                        children: <Widget>[Text(article.niceDate)],
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
                article.type == 1
                    ? Image(
                    width: ScreenUtil.getInstance().setWidth(80),
                    height: ScreenUtil.getInstance().setWidth(80),
                    image: AssetImage('assets/img/icon_top.png'))
                    : Container(),
              ],
            )));
  }

  ///保存状态
  @override
  bool get wantKeepAlive => true;

  ///获取Banner数据
  void getBanner() {
    HttpUtils.getInstance().get(Api.BANNER, successCallBack: (data) {
      print(data);
      List responseJson = json.decode(data);
      List<BannerEntity> responseList =
      responseJson.map((json) => BannerEntity.fromJson(json)).toList();
      print(responseList.toString());
      setState(() {
        bannerList.clear();
        bannerList.addAll(responseList);
      });
    });
  }

  ///获取置顶文章数据
  void loadArticleTop() {
    HttpUtils.getInstance().get(Api.ARTICLE_TOP, successCallBack: (data) {
      List responseJson = json.decode(data);
      List<ArticleEntity> responseList =
      responseJson.map((json) => ArticleEntity.fromJson(json)).toList();
      articleList.clear();
      articleList.addAll(responseList);
    }, errorCallBack: () {
      _loadState = LoadState.error;
    }
    );
    loadArticleData();
  }

  void loadArticleData() {
    HttpUtils.getInstance().get('${Api.ARTICLE_LIST}$currentPage/json',
        successCallBack: (data) {
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
        }, errorCallBack: () {
          _loadState = LoadState.error;
        }
    );
  }
}
