import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "欢迎页",
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'SplashPage',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.pink,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.blueAccent,   //color   和decoration 不能重复使用
          decoration: new BoxDecoration(  // 渐变色
            gradient: const LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.amber,
                  Colors.pink
                ])
          ),
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),//内边距
          margin: const EdgeInsets.all(10.0),//外边距
          child: Image.network(
            "https://img.mukewang.com/5d117c6508c2e8fe06000338.jpg",
            fit: BoxFit.cover,
          ),


        ),
      ),
    );
  }
}
