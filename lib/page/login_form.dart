import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/const/Config.dart';
import 'package:flutter_app2/event/login_event.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/widget/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LoginFormPage extends StatefulWidget {

  PageController _pageController;
  LoginFormPage(this._pageController);
  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {

  String _name;
  String _pwd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: ScreenUtil.getInstance().setHeight(110),
        ),
        GestureDetector(
            onTap: (){
              widget._pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Visibility(
                 visible: true,
                 child: IconButton(
                   icon: Icon(Icons.arrow_left),
                   disabledColor: Color(int.parse("0x00000000")),
                 ),
               ),

               Text(
                 '去注册',
                 style: TextStyle(
                   color: Colors.blue,
                   fontSize: ScreenUtil.getInstance().setSp(40),
                 ),
               ),
               Visibility(
                 visible: true,
                 child: IconButton(
                   icon: Icon(Icons.arrow_right),
                   disabledColor: Colors.lightBlue,
                 )
               ),

             ],
           ),

        ),
        Container(
          margin: EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(110)),
          width: ScreenUtil.getInstance().setWidth(750),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  hintText: '请输入用户名',
                  fillColor: Colors.transparent,
                  prefixIcon: Icon(Icons.account_circle)),
                onChanged: (name){
                  _name = name;
                },
              ),
              Container(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              TextField(
                decoration: InputDecoration(
                    filled: true,
                    hintText: '请输入密码',
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.lock_open)),
                obscureText: true,//是否是密码
                onChanged: (pwd){
                  _pwd = pwd;
                },
              ),
              Container(
                width: ScreenUtil.screenWidth,
                margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(85)),
                height: ScreenUtil.getInstance().setHeight(120),
                child: RaisedButton(
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  child: Text(
                    '登 录',
                    style:TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40),
                    ),
                  ),
                  shape: StadiumBorder(
                      side: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.transparent
                      )
                  ),
                  onPressed: (){
                      doLogin();
                  },
                ),
              )
            ],
          ),
        )


      ],
    );
  }

  void doLogin() {
   var params = {'username':_name,'password':_pwd};
   HttpUtils.getInstance().post(Api.LOGIN,params:params,successCallBack:(data){
        saveInfo(data);
   },errorCallBack: (code,msg){
     T.showToast(msg);
   });

  }

  void saveInfo(data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.spPwd, _pwd);
    await prefs.setString(Config.spUserInfo, data);
    eventBus.fire(LoginEvent());
    T.showToast('登录成功!');
    Navigator.of(context).pop();
  }
}
