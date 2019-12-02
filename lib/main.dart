
import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/model/user_info_entity.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/page/main_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const/Api.dart';
import 'const/Config.dart';

void main() => runApp(MyApp());

EventBus eventBus = EventBus();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashViewState();
  }
}

class SplashViewState extends State<SplashView> {
  //获取本地用户信息
  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString(Config.spUserInfo);
    if (null != info && info.isNotEmpty) {
      Map userMap = json.decode(info);
      UserInfoEntity userEntity = new UserInfoEntity.fromJson(userMap);
      String _name = userEntity.username;
      String _pwd = prefs.getString(Config.spPwd);
      if (null != _pwd && _pwd.isNotEmpty) {
        doLogin(_name, _pwd);
      }
    }else{
      countdown();
    }
  }

//  登录
  doLogin(String _name, String _pwd) {
    var data;
    data = {'username': _name, 'password': _pwd};
    HttpUtils.getInstance().post(Api.LOGIN, params: data,
        successCallBack: (data) {
          saveInfo(data);
          Navigator.of(context).pop();
        }, errorCallBack: (code, msg) {});
  }

//  保存用户信息
  void saveInfo(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.spUserInfo, data);
     countdown();
  }

  void countdown() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MainPage()),
          (route) => route == null,
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return new Scaffold(
        body: new Container(
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight,
            child: new Image(
              image: AssetImage('assets/img/splash_bg.png'),
              width: ScreenUtil.screenWidth,
              height: ScreenUtil.screenHeight,
              fit: BoxFit.fill,
            )));
  }
}


