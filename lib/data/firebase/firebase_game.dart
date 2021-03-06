import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/data/firebase/firebase_log.dart';
import 'package:findgamemates/model/database_response.dart';
import 'package:findgamemates/model/game_comment.dart';
import 'package:findgamemates/model/game_post.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/utils/log_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FirebaseGame extends GetxService {
  late DatabaseReference databaseReference;
  late DatabaseReference commentsReference;
  late CollectionReference gameFirestore;
  late CollectionReference commentsFirestore;
  late FirebaseAuth firebaseAuth;
  final UserDatabase userDatabase = Get.put(UserDatabase());
  final FirebaseLog firebaseLog = Get.put(FirebaseLog());

  late DocumentSnapshot lastGameSnapshot;

  @override
  void onInit() {
    gameFirestore = FirebaseFirestore.instance.collection("games");
    commentsFirestore = FirebaseFirestore.instance.collection("comments");
    databaseReference = FirebaseDatabase.instance.reference().child("games");
    commentsReference = FirebaseDatabase.instance.reference().child("comments");
    firebaseAuth = FirebaseAuth.instance;
    super.onInit();
  }

  Future<DatabaseResponse> createGame(GamePost gamePost) async {
    try {
      //DatabaseReference gameRef = databaseReference.push();
      var gameRef = await gameFirestore.add(gamePost.toJson());
      gamePost.id = gameRef.id;
      await gameRef.set(gamePost.toJson());
      return DatabaseResponse(result: true, data: gamePost);
    } on Exception catch (e) {
      firebaseLog.writeLog(LogUtils.databaseError + e.toString());
      return DatabaseResponse(result: true, data: gamePost);
    }
  }

  Future<List<GamePost>> getGameList(String? filter, GameType? gameType,
      String? provience, String? lastId) async {
    try {
      List<GamePost> gameList = [];
      var query = gameFirestore.where('active', isEqualTo: true);
      if (lastId != null) {
        query = query.startAtDocument(lastGameSnapshot);
      }
      query = query.limit(10);
      await query.get().then((value) {
        var mapEntry = value.docs;
        for (var data in mapEntry) {
          GamePost gamePost = GamePost.fromJson(data);
          gameList.add(gamePost);
        }
        lastGameSnapshot = mapEntry.last;
      });
      return gameList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<GameComment>> getComments(String postId) async {
    try {
      List<GameComment> commentList = [];
      //var postRef = commentsReference.child(postId);
      var postRef = commentsFirestore.where('postId', isEqualTo: postId);
      await postRef.where('active', isEqualTo: true).get().then((value) {
        try {
          var mapEntry = value.docs;
          for (var data in mapEntry) {
            Map<String, dynamic> json =
                Map<String, dynamic>.from(data.data() as Map);
            GameComment gameComment = GameComment.fromJson(json);
            commentList.add(gameComment);
          }
        } catch (e) {
          debugPrint(e.toString());
          return [];
        }
      });
      return commentList;
    } catch (e) {
      return [];
    }
  }

  Future<GameComment?> addComment(String postId, String comment) async {
    try {
      GameComment gameComment = GameComment(
          id: "temporary_id",
          postId: postId,
          senderId: firebaseAuth.currentUser!.uid,
          senderName: userDatabase.getUser()!.displayName!,
          sendTime: DateTime.now().toUtc().toString(),
          comment: comment,
          active: true);
      var commentRef = await commentsFirestore.add(gameComment.toJson());
      gameComment.id = commentRef.id;
      commentRef.set(gameComment.toJson());
      return gameComment;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
