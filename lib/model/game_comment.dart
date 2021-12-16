class GameComment{

  String id;
  String postId;
  String senderId;
  String senderName;
  String sendTime;
  String comment;
  bool active;

  GameComment({
    required this.id,
    required this.postId,
    required this.senderId,
    required this.senderName,
    required this.sendTime,
    required this.comment,
    required this.active
  });

  Map<String, dynamic> toJson() => {
    "id" : id,
    "postId" :postId,
    "senderId" :senderId,
    "senderName": senderName,
    "sendTime" : sendTime,
    "comment" :comment,
    "active": active
  };

  static fromJson(Map<String, dynamic> json){
    return GameComment(
      id: json["id"],
      postId: json["postId"],
      senderId: json["senderId"],
      senderName: json["senderName"],
      sendTime: json["sendTime"],
      comment: json["comment"],
      active: json["active"]
    );
  }

}