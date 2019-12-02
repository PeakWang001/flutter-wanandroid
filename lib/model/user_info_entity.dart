
///用户
class UserInfoEntity{

  bool admin;
  List<Null> chapterTops;
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String publicName;
  String token;
  int type;
  String username;

  UserInfoEntity(
  {this.admin,
  this.chapterTops,
  this.collectIds,
  this.email,
  this.icon,
  this.id,
  this.nickname,
  this.password,
  this.publicName,
  this.token,
  this.type,
  this.username});

  UserInfoEntity.fromJson(Map<String, dynamic> json) {
  admin = json['admin'];
  if (json['chapterTops'] != null) {
  chapterTops = new List<Null>();
  }
  collectIds = json['collectIds'].cast<int>();
  email = json['email'];
  icon = json['icon'];
  id = json['id'];
  nickname = json['nickname'];
  password = json['password'];
  publicName = json['publicName'];
  token = json['token'];
  type = json['type'];
  username = json['username'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['admin'] = this.admin;
  if (this.chapterTops != null) {
  data['chapterTops'] = [];
  }
  data['collectIds'] = this.collectIds;
  data['email'] = this.email;
  data['icon'] = this.icon;
  data['id'] = this.id;
  data['nickname'] = this.nickname;
  data['password'] = this.password;
  data['publicName'] = this.publicName;
  data['token'] = this.token;
  data['type'] = this.type;
  data['username'] = this.username;
  return data;
  }
  }