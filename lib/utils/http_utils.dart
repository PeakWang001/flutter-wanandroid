
import 'dart:convert';
///三方依赖
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/page/login.dart';

///自己项目中的导包
import '../const/Api.dart';
import '../const/Config.dart';
import '../const/result_code.dart';
import '../model/base_entity.dart';

///http Dio 网络请求封装管理类
class HttpUtils{
  static String _baseUrl = Api.BASE_URL;
  static HttpUtils _instance ;
  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = new CancelToken();

  ///单例模式
  static HttpUtils getInstance(){
    if(_instance==null) _instance = HttpUtils();
    return _instance;
  }

  ///初始化数据
  HttpUtils(){
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = new BaseOptions(
      //请求地址，可以包含子路径
      baseUrl: _baseUrl,
      //连接服务器超时时间,单位毫秒
      connectTimeout: 10000,
      //响应时间,单位毫秒
      receiveTimeout: 15000,
      //请求头
      headers: {HttpHeaders.acceptHeader:'*'},
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      //      contentType: ContentType.json,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      //plain 文本（字符串）     json Json      stream 二进制
      responseType: ResponseType.plain,
    );
    //初始化 Dio
    dio = new Dio(options);
    //Cookie 配置
    dio.interceptors.add(CookieManager(CookieJar()));
    //日志打印
    if(Config.isDebug) {
      dio.interceptors.add(
          InterceptorsWrapper(
          onRequest: (RequestOptions requestOptions){
            print("\n================== 请求数据 ==========================");
            print("url = ${requestOptions.uri.toString()}");
            print("headers = ${requestOptions.headers}");
            print("params = ${requestOptions.data}");
          },
          onResponse: (Response response){
            print("\n================== 响应数据 ==========================");
            print("code = ${response.statusCode}");
            print("data = ${response.data}");
            print("\n");
          },
          onError: (DioError e) {
            print("\n================== 错误响应数据 ======================");
            print("type = ${e.type}");
            print("message = ${e.message}");
            print("\n");
          }
        ),
      );
    }

  }

  /// get请求
  get(url ,{params,options,cancelToken,BuildContext context,Function successCallBack,Function errorCallBack}) async{
    _request(url,'get',params: params,options:options,cancelToken:cancelToken,context:context,successCallBack:successCallBack,errorCallBack:errorCallBack);
  }

  /// post请求
  post(url ,{params,options,cancelToken,BuildContext context,Function successCallBack,Function errorCallBack}) async{
    _request(url,'post',params: params,options:options,cancelToken:cancelToken,context:context,successCallBack:successCallBack,errorCallBack:errorCallBack);
  }

  ///request
  _request(url ,method,{params,options,cancelToken,BuildContext context,Function successCallBack,Function errorCallBack})async{
    Response response;
    try{
      if('get'==method){
        response = await dio.get(url,queryParameters: params) ;
      }else{
        response = await dio.post(url,queryParameters: params) ;
      }
    }on DioError catch (e){
      formatError(e,errorCallBack);
    }
    if(null != response.data){
      BaseEntity baseEntity = BaseEntity.fromJson(json.decode(response.data));
      if(null != baseEntity){
        switch(baseEntity.errorCode){
        //未登录的错误码为-1001，其他错误码为-1，成功为0
          case 0:
            successCallBack(jsonEncode(baseEntity.data));
            break;
          case -1001:
            errorCallBack(baseEntity.errorCode, baseEntity.errorMsg);
            if (null != context) {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) {
                    return new Scaffold(
                      //body: new LoginPage(),
                      body: new LoginPage(),
                    );
                  },
                ),
              );
            }
            break;
          default:
            errorCallBack(baseEntity.errorCode, baseEntity.errorMsg);
            break;
        }
      }else{
        errorCallBack(ResultCode.NETWORK_JSON_EXCEPTION, '网络数据有问题');
      }

    }else{
      errorCallBack(ResultCode.NETWORK_JSON_EXCEPTION, '网络不稳定，请稍后重试');
    }

  }


  /*
   * error统一处理
   */
  void formatError(DioError e,Function errorCallBack) {

    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
      errorCallBack(DioErrorType.CONNECT_TIMEOUT,"连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
      errorCallBack(DioErrorType.SEND_TIMEOUT,"请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
      errorCallBack(DioErrorType.RECEIVE_TIMEOUT,"响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
      errorCallBack(DioErrorType.RESPONSE,"出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
      errorCallBack(DioErrorType.CANCEL,"请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
      errorCallBack(DioErrorType.DEFAULT,"未知错误");
    }
  }



}
