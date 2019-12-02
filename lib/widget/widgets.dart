import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res/colors.dart';

class ProgressView extends StatelessWidget {
  double width = 0;
  double height = 0;

  ProgressView();

  ProgressView.size(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: ScreenUtil.getInstance().setWidth(100),
          height: ScreenUtil.getInstance().setHeight(100),
          child: CircularProgressIndicator(
            strokeWidth: ScreenUtil.getInstance().setWidth(8),
          ),
        ),
      ),
    );
  }
}

///四种视图状态
enum LoadState { success, error, loading, empty }

///状态布局
class StateView extends StatelessWidget {
  LoadState status;

  GestureTapCallback onTap;
  Widget successWidget;

  StateView(
    this.status, {
    Key key,
    this.onTap,
    this.successWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadState.loading:

        ///加载中
        return Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProgressView(),
              Container(
                height: ScreenUtil.getInstance().setHeight(20),
              ),
              Text(
                '加载中...',
                style: TextStyle(color: Colours.color_primary),
              )
            ],
          ),
        );
        break;
      case LoadState.error:

        ///失败
        return Container(
          width: double.infinity,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/img/ic_error.png'),
                  width: ScreenUtil.getInstance().setWidth(200),
                  height: ScreenUtil.getInstance().setHeight(200),
                ),
                Container(
                  height: ScreenUtil.getInstance().setHeight(20),
                ),
                Text('数据加载失败,请检查您的网络设置'),
                Container(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                Text('点击重新加载')
              ],
            ),
          ),
        );
        break;
      case LoadState.empty:

        ///空数据
        return Container(
          width: double.infinity,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/img/ic_empty.png'),
                  width: ScreenUtil.getInstance().setWidth(200),
                  height: ScreenUtil.getInstance().setHeight(200),
                ),
                Container(
                  height: ScreenUtil.getInstance().setHeight(20),
                ),
                Text('空空如也(#^.^#)'),
                Container(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                Text('点击重新加载')
              ],
            ),
          ),
        );
        break;
      case LoadState.success:
        return successWidget;
        break;
      default:
        return Container();
        break;
    }
  }
}
