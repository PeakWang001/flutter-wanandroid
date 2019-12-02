
///基础数据实体类
class BaseEntity{
  //返回实体
  var data;
  //错误代码  0为没有错误
  int errorCode;
  //错误信息
  String errorMsg;

  BaseEntity({this.data, this.errorCode, this.errorMsg});


  BaseEntity.fromJson(Map<String,dynamic> json){
    data = json['data'];
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String , dynamic> toJson(){
    final Map<String,dynamic> map = new Map();
    map['data'] = this.data;
    map['errorCode'] = this.errorCode;
    map['errorMsg'] = this.errorMsg;
    return map;
}

}