import 'package:findgamemates/model/game_types.dart';

class GamePost {
  String id;
  String createrId;
  String createTime;
  String createrName;
  String? updatedTime;
  String title;
  String desc;
  GameType gameType;
  String province;
  bool active;

  GamePost(
      {required this.id,
      required this.createrId,
      required this.createTime,
      this.updatedTime,
      required this.title,
      required this.desc,
      required this.gameType,
      required this.province,
      required this.active,
      required this.createrName});

  Map<String, dynamic> toJson() => {
        "id": id,
        "createrId": createrId,
        "createTime": createTime,
        "updatedTime": updatedTime,
        "title": title,
        "desc": desc,
        "gameType": gameType.toString(),
        "province": province,
        "active": active,
        "createrName": createrName
      };

  static fromJson(var json) {
    return GamePost(
      id: json["id"],
      createTime: json["createTime"],
      createrId: json["createrId"],
      desc: json["desc"],
      gameType: GameType.values
          .firstWhere((element) => element.toString() == json["gameType"]),
      province: json["province"],
      title: json["title"],
      active: json["active"],
      createrName: json["createrName"],
    );
  }
}
