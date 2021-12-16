import 'dart:convert';

import 'package:findgamemates/data/firebase/firebase_log.dart';
import 'package:findgamemates/model/database_response.dart';
import 'package:findgamemates/model/game_comment.dart';
import 'package:findgamemates/model/game_post.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/utils/log_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FirebaseGame extends GetxService{

  late DatabaseReference databaseReference;
  late DatabaseReference commentsReference;
  late FirebaseAuth firebaseAuth;
  FirebaseLog firebaseLog = Get.put(FirebaseLog());

  @override
  void onInit() {
    databaseReference = FirebaseDatabase.instance.reference().child("games");
    commentsReference = FirebaseDatabase.instance.reference().child("comments");
    firebaseAuth = FirebaseAuth.instance;
  }

  Future<DatabaseResponse> createGame(GamePost gamePost) async{
    try{
      DatabaseReference gameRef = databaseReference.push();
      gamePost.id = gameRef.key;
      await gameRef.set(gamePost.toJson());
      return DatabaseResponse(result: true,data: gamePost);
    } on Exception catch(e){
      firebaseLog.writeLog(LogUtils.databaseError+e.toString());
      return DatabaseResponse(result: true,data: gamePost);
    }
  }

  Future<List<GamePost>> getGameList(String? filter, GameType? gameType, String? provience) async {
    List<GamePost> gameList = [];
    await databaseReference.orderByChild("active").equalTo(true).once().then((value) {
      var mapEntry = value.value.entries.toList();
      mapEntry.forEach((data){
        GamePost gamePost = GamePost.fromJson(data.value);
        gameList.add(gamePost);
      });
    });
    return gameList;
  }

  Future<List<GameComment>> getComments(String postId) async{
    List<GameComment> commentList = [];
    var postRef = commentsReference.child(postId);
    await postRef.orderByChild("active").equalTo(true).once().then((value){
      try{
        var mapEntry = value.value.entries.toList();
        mapEntry.forEach((data){
          Map<String, dynamic> json = Map<String, dynamic>.from(data.value);
          GameComment gameComment = GameComment.fromJson(json);
          commentList.add(gameComment);
        });
      }catch(e){
        debugPrint(e.toString());
        return [];
      }
    });
    return commentList;
  }

  Future<GameComment> addComment(String postId, String comment) async{
    DatabaseReference dbRef = commentsReference.child(postId).push();
    //todo: sendername ekle
    GameComment gameComment = GameComment(
      id: dbRef.key,
      postId: postId,
      senderId: firebaseAuth.currentUser!.uid,
      senderName: "asd",
      sendTime: DateTime.now().toUtc().toString(),
      comment: comment,
      active: true
    );
    await dbRef.set(gameComment.toJson());
    return gameComment;
  }
}