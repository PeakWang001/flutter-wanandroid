class Api {

  static const String BASE_URL = "https://www.wanandroid.com/";

  //首页banner
  static const String BANNER = "banner/json";

  //首页文章列表
  static const String ARTICLE_LIST = "article/list/";

  //置顶文章
  static const String ARTICLE_TOP = "article/top/json";

  //体系数据
  static const String TREE = "tree/json";

  //导航数据
  static const String NAVI = "navi/json";

  //项目分类
  static const String PROJECT = "project/tree/json";

  //项目列表数据
  static const String PROJECT_LIST = "project/list/";

  //登录
  static const String LOGIN = "user/login";

  //注册
  static const String REGISTER = "user/register";

  //退出登录
  static const String LOGOUT = "user/logout/json";

  //搜索热词
  static const String HOT_KEY = "hotkey/json";

  //搜索
  static const String QUERY = "article/query/0/json";

  //收藏文章列表
  static const String COLLECT_LIST = "lg/collect/list/";

  //收藏站内文章
  static const String COLLECT = "lg/collect/";

  //取消收藏-文章列表
  static const String UN_COLLECT_ORIGIN_ID = "lg/uncollect_originId/";

  //取消收藏-收藏页面
  static const String UN_COLLECT = "lg/uncollect/";

  //获取公众号列表
  static const String WXARTICLE_CHAPTERS = "wxarticle/chapters/json";

  //查看某个公众号历史数据
  static const String WXARTICLE_LIST = "wxarticle/list/";

  //获取个人积分，需要登录后访问
  static const String COIN_USERINFO = "lg/coin/userinfo/json";

  //积分排行榜接口
  static const String COIN_RANK = "coin/rank/";

  //广场列表数据
  static const String USER_ARTICLE_LIST = "user_article/list/";
}