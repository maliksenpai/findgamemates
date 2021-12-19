import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/data/firebase/firebase_game.dart';
import 'package:findgamemates/data/firebase/firebase_log.dart';
import 'package:findgamemates/model/database_response.dart';
import 'package:findgamemates/model/game_comment.dart';
import 'package:findgamemates/model/game_post.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/utils/log_utils.dart';
import 'package:get/get.dart';

class GameGet extends GetxController {
  FirebaseGame firebaseGame = Get.put(FirebaseGame());
  FirebaseLog firebaseLog = Get.put(FirebaseLog());
  UserDatabase userDatabase = Get.put(UserDatabase());
  Rx<List<GamePost>> postList = Rx([]);
  List<GamePost> notFilteredList = [];

  Rx<List<GameComment>?> currComments = Rx(null);

  @override
  void onInit() async {
    if (postList.value.isEmpty) {
      postList.value = await firebaseGame.getGameList(null, null, null);
      postList.value.sort((a,b) => a.createTime.compareTo(b.createTime));
      notFilteredList.addAll(postList.value);
    }
    super.onInit();
  }

  void filterGameList(String filter, GameType? gameType, String? province) {
    postList.value = notFilteredList.where((element) =>
    (element.gameType == gameType || gameType == GameType.all || gameType == null) &&
        (element.title.contains(filter) || element.desc.contains(filter)) &&
        (element.province == province || province == "Hepsi" || province == null)
    ).toList();
    postList.value.sort((a,b) => a.createTime.compareTo(b.createTime));
    postList.refresh();
  }

  Future<bool> createGame(String title, String desc, String province, GameType gameType) async {
    //todo: add uuid
    GamePost gamePost = GamePost(id: "asd", createTime: DateTime.now().toUtc().toString(), createrId: userDatabase.getUser()!.uid!, title: title, desc: desc, province: province, gameType: gameType, active: true);
    DatabaseResponse databaseResponse = await firebaseGame.createGame(gamePost);
    if (databaseResponse.result) {
      firebaseLog.writeLog(databaseResponse.data.id + "  " + LogUtils.createdGame);
    }
    return databaseResponse.result;
  }

  Future getListComment(String postId) async {
    currComments.value = await firebaseGame.getComments(postId);
    currComments.value!.sort((a,b) => a.sendTime.compareTo(b.sendTime));
    currComments.refresh();
  }

  Future<GameComment?> addComment(String postId, String comment) async{
    try{
      GameComment gameComment = await firebaseGame.addComment(postId, comment);
      currComments.value!.add(gameComment);
      currComments.refresh();
      return gameComment;
    }catch(e){
      return null;
    }
  }
}
