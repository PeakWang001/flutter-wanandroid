
///积分实体类
class CoinInfoEntity {
  int coinCount;
  int level;
  int rank;
  int userId;
  String username;

  CoinInfoEntity({this.coinCount, this.level, this.rank, this.userId, this.username});

  CoinInfoEntity.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    level = json['level'];
    rank = json['rank'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinCount'] = this.coinCount;
    data['level'] = this.level;
    data['rank'] = this.rank;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}