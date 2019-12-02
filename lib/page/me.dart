import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/const/Config.dart';
import 'package:flutter_app2/model/coin_info_entity.dart';
import 'package:flutter_app2/model/user_info_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/collect.dart';
import 'package:flutter_app2/widget/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import '../main.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {

  UserInfoEntity _userInfoEntity;
  CoinInfoEntity _coinInfoEntity;
  String headPath;




  @override
  void initState() {
    super.initState();
    eventBus.on().listen((data) {
      print('eventBus');
      getUserInfo();
      getCoinCount();
    });
    if (null == _userInfoEntity) {
      getUserInfo();
    }
    if (null == _coinInfoEntity) {
      getCoinCount();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
      Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            decoration: headPath == null||File(headPath)==null
                ? BoxDecoration(
              color: Color(0xff4282f4),
            )
                : new BoxDecoration(
              image: new DecorationImage(
                image:FileImage(File(headPath)),
                fit: BoxFit.fill,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: new Column(
                children: <Widget>[
                  AppBar(
                    actions: <Widget>[
                      new InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(
                              ScreenUtil.getInstance().setWidth(55)),
                          child: new Image(
                            image: AssetImage('assets/img/ic_rank.png'),
                          ),
                        ),
                        onTap: () {
                        },
                      )
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0, //去掉阴影效果
                  ),
                  Container(
                    height: ScreenUtil.getInstance().setWidth(50),
                  ),
                  new GestureDetector(
                    child: new ClipOval(
                      child: new Image(
                        image: null == headPath
                            ? AssetImage('assets/img/img_user_head.png')
                            : FileImage(new File(headPath)),
                        width: ScreenUtil.getInstance().setWidth(220),
                        height: ScreenUtil.getInstance().setWidth(220),
                      ),
                    ),
                    onTap: () async {
                      if (null != _userInfoEntity) {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        File croppedFile = await ImageCropper.cropImage(
                            sourcePath: image.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                            ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: '裁剪',
                                toolbarColor: Color(0xff4282f4),
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.square,
                                hideBottomControls: true,
                                lockAspectRatio: true),
                            iosUiSettings: IOSUiSettings(
                              minimumAspectRatio: 1.0,
                            ));
                        if (null != croppedFile) {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          prefs.setString(
                              Config.spHeadPath, croppedFile.path);
                          setState(() {
                            headPath = croppedFile.path;
                          });
                        }
                      } else {
                        goLogin();
                      }
                    },
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(30),
                  ),
                  new Text(
                    null == _userInfoEntity ? "去登录" : _userInfoEntity.nickname,
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(60),
                        color: Colors.white),
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(20),
                  ),
                  new Text(
                    null == _userInfoEntity ? "ID:---" : "ID:${_userInfoEntity.id}",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(35),
                        color: Colors.white),
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(20),
                  ),
                  new Text(
                    null == _coinInfoEntity
                        ? "等级:---   排名：--"
                        : "等级:1   排名：${_coinInfoEntity.rank}",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(35),
                        color: Colors.white),
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(50),
                  ),
                ],
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil.getInstance().setWidth(45),
                            top: ScreenUtil.getInstance().setWidth(45),
                            bottom: ScreenUtil.getInstance().setWidth(45),
                            right: ScreenUtil.getInstance().setWidth(35)),
                        child: new Image(
                          image: AssetImage('assets/img/img_star.png'),
                          width: ScreenUtil.getInstance().setWidth(60),
                          height: ScreenUtil.getInstance().setWidth(60),
                        ),
                      ),
                      new Expanded(
                          child: new Text(
                            "我的积分",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(40),
                                color: Colors.black54),
                          )),
                      new Text(
                        null == _coinInfoEntity
                            ? ""
                            : "${_coinInfoEntity.coinCount}",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(40),
                            color: Colors.black38),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(
                            right: ScreenUtil.getInstance().setWidth(45)),
                        child: IconButton(
                            icon: Image(
                              image: AssetImage('assets/img/img_right.png'),
                              width: ScreenUtil.getInstance().setWidth(55),
                              height: ScreenUtil.getInstance().setWidth(55),
                            )),
                      )
                    ],
                  ),
                  new GestureDetector(
                    onTap: () {
                      if(null != _userInfoEntity){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                          return CollectPage();
                        }));
                      }else{
                        T.showToast('请先登录!');
                      }
                    },
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil.getInstance().setWidth(45),
                              top: ScreenUtil.getInstance().setWidth(45),
                              bottom: ScreenUtil.getInstance().setWidth(45),
                              right: ScreenUtil.getInstance().setWidth(35)),
                          child: new Image(
                            image: AssetImage('assets/img/img_heart.png'),
                            width: ScreenUtil.getInstance().setWidth(60),
                            height: ScreenUtil.getInstance().setWidth(60),
                          ),
                        ),
                        new Expanded(
                            child: new Text(
                              "我的收藏",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(40),
                                  color: Colors.black54),
                            )),
                        new Padding(
                          padding: EdgeInsets.only(
                              right: ScreenUtil.getInstance().setWidth(45)),
                          child: IconButton(
                              icon: Image(
                                image: AssetImage('assets/img/img_right.png'),
                                width: ScreenUtil.getInstance().setWidth(55),
                                height: ScreenUtil.getInstance().setWidth(55),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    )],
    )
    ,
    );
  }

  void goLogin() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            body: new LoginPage(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void getUserInfo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfo = prefs.getString(Config.spUserInfo);
    String spHeadPath = prefs.getString(Config.spHeadPath);
    if (null != userInfo && userInfo.isNotEmpty) {
      print('userInfo');
      Map userMap = json.decode(userInfo);
      setState(() {
        print('_userInfoEntity');
        _userInfoEntity = UserInfoEntity.fromJson(userMap);
      });
    }
    if(null != spHeadPath && spHeadPath.isNotEmpty){
      setState(() {
        headPath = spHeadPath;
      });

    }
  }

  void getCoinCount() {
    HttpUtils.getInstance().get(Api.COIN_USERINFO, successCallBack: (data) {
      Map userMap = json.decode(data);
      setState(() {
        _coinInfoEntity = CoinInfoEntity.fromJson(userMap);
      });
    }, errorCallBack: (code, msg) {
      T.showToast(msg);
    });
  }
}
