import 'package:flutter/material.dart';
import 'package:flutter_app2/page/login_form.dart';
import 'package:flutter_app2/page/register_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LoginPage extends StatelessWidget {

  var _pageController = new PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/login_bg.png'),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: ScreenUtil.getInstance().setHeight(55),
          ),
          Expanded(
            flex: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: ScreenUtil.getInstance().setWidth(1080),
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil.getInstance().setHeight(120),
                  padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(30)),
                  child: GestureDetector(
                    child: Image.asset('assets/img/ic_close.png'),
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Image(
                  image: AssetImage('assets/img/logo.png'),
                  width: ScreenUtil.getInstance().setWidth(270),
                  height: ScreenUtil.getInstance().setWidth(270),
                ),
                Container(
                  height: ScreenUtil.getInstance().setWidth(45),
                ),
                new Text(
                  "欢迎使用",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(60),
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                new Container(
                  height: ScreenUtil.getInstance().setWidth(15),
                ),
                new Text(
                  "本App为WanAndroid Flutter版本项目",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(30),
                      color: Colors.white,
                      decoration: TextDecoration.none),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1185,
            child: PageView.builder(
                itemBuilder: (BuildContext context , int index){
                  return index == 0
                      ? LoginFormPage(_pageController)
                      : RegisterFormPage(_pageController);
                },
              itemCount: 2,
              controller: _pageController,

                ),
          )


        ],
      ),
    );
  }
}
