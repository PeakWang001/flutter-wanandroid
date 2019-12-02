
import 'package:flutter/material.dart';
import 'package:flutter_app2/const/Api.dart';
import 'package:flutter_app2/utils/http_utils.dart';
import 'package:flutter_app2/widget/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterFormPage extends StatefulWidget {

  PageController _pageController;
  RegisterFormPage(this._pageController);
  @override
  _RegisterFormPageState createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {

  String _name;
  String _pwd;
  String _pwd2;

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
            widget._pageController.animateToPage(0,
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
                  disabledColor:Colors.lightBlue,
                ),
              ),

              Text(
                '去登录',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: ScreenUtil.getInstance().setSp(40),
                ),
              ),
              Visibility(
                visible: true,
                child: IconButton(
                  icon: Icon(Icons.arrow_left),
                  disabledColor: Color(int.parse("0x00000000")),
                ),
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
                  _pwd2 = pwd;
                },
              ),
              Container(
                width: ScreenUtil.screenWidth,
                margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(85)),
                height: ScreenUtil.getInstance().setHeight(120),
                child: RaisedButton(
                  textColor: Colors.white,
                  child: Text(
                    '注 册',
                    style:TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(40)
                    ),
                  ),
                  color: Colors.lightBlue,
                  shape: StadiumBorder(
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.transparent
                    )

                  ),
                  onPressed: (){
                      doRegister();
                  },
                ),
              )

            ],
          ),
        )
      ],
    );
  }


  void doRegister() {
    var params = {'username':_name,'password':_pwd,'repassword':_pwd2};
    HttpUtils.getInstance().post(Api.REGISTER,params: params,successCallBack: (data){
      T.showToast("注册成功,去登录吧(#^.^#)");
      widget._pageController.animateToPage(0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease);
    },errorCallBack: (code,msg){
        T.showToast(msg);
    });

  }
}
