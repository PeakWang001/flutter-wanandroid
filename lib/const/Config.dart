


///项目配置信息
class Config {
  ///debug 模式
  static final bool isDebug = true ;
  ///theme 主题  TODO 白天黑夜主题
  static final bool dark = false;
  //SharedPreferences  密码
  static final String spPwd = 'sp_pwd';
  //SharedPreferences  用户
  static final String spUserInfo = 'sp_user_info';
  //SharedPreferences  头像
  static final String spHeadPath = 'sp_head_path';

}

class LoadStatus {
  static const int fail = -1;
  static const int loading = 0;
  static const int success = 1;
  static const int empty = 2;
}