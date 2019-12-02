import 'package:flutter/material.dart';
import 'package:flutter_app2/page/project_page.dart';
import 'package:flutter_app2/page/system.dart';
import 'package:flutter_app2/page/we_chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home.dart';
import 'me.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  PageController _pageController = new PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return new Scaffold(
      body: new PageView.builder(
        onPageChanged: (i) {
          setState(() {
            if (index != i) {
              index = i;
            }
          });
        },
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return HomePage();
              break;
            case 1:
              return ProjectPage();
              break;
            case 2:
              return WeChatPage();
              break;
            case 3:
              return SystemPage();
              break;
            case 4:
              return MePage();
              break;
          }
          return null;
        },
        itemCount: 5,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 0
                  ? Image(
                      image: AssetImage('assets/img/ic_home_selected.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : Image(
                      image: AssetImage('assets/img/ic_home_normal.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: Text(
                '首页',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil.getInstance().setWidth(26)),
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 1
                  ? Image(
                      image: AssetImage('assets/img/ic_project_selected.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : Image(
                      image: AssetImage('assets/img/ic_project_normal.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: Text(
                '项目',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil.getInstance().setWidth(26)),
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 2
                  ? Image(
                      image: AssetImage('assets/img/ic_wechat_selected.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : Image(
                      image: AssetImage('assets/img/ic_wechat_normal.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: Text(
                '公众号',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil.getInstance().setWidth(26)),
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 3
                  ? Image(
                      image: AssetImage('assets/img/ic_book_selected.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : Image(
                      image: AssetImage('assets/img/ic_book_normal.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: Text(
                '体系',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil.getInstance().setWidth(26)),
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 4
                  ? Image(
                      image: AssetImage('assets/img/ic_mine_selected.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : Image(
                      image: AssetImage('assets/img/ic_mine_normal.png'),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: Text(
                '我的',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil.getInstance().setWidth(26)),
              )),
        ],
        currentIndex: index,
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: Duration(microseconds: 300), curve: Curves.ease);
        },
      ),
    );
  }
}
