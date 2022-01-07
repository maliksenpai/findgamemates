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
  int gameCount = 0;
  int gameCountIncrement = 10;
  int lastPulledPostCount = 0;
  RxBool loading = RxBool(false);

  Rx<List<GameComment>?> currComments = Rx(null);


  @override
  void onInit() async {
    if (postList.value.isEmpty) {
      gameCount +=  gameCountIncrement;
      getGames(null);
    }
    super.onInit();
  }

  Future getGames(String? lastId) async{
    if(lastId == null){
      var iterable = await firebaseGame.getGameList(null, null, null, lastId);
      lastPulledPostCount = iterable.length;
      postList.value = iterable;
    }else{
      var iterable = await firebaseGame.getGameList(null, null, null, lastId);
      lastPulledPostCount = iterable.length;
      postList.value.addAll(iterable);
    }
    postList.value.sort((a,b) => a.createTime.compareTo(b.createTime));
    notFilteredList.addAll(postList.value);
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
    var user = userDatabase.getUser();
    GamePost gamePost = GamePost(id: "temporary_value", createTime: DateTime.now().toUtc().toString(), createrId: user!.uid!, title: title, desc: desc, province: province, gameType: gameType, active: true,createrName: user.displayName!);
    DatabaseResponse databaseResponse = await firebaseGame.createGame(gamePost);
    addNewGame(databaseResponse.data);
    if (databaseResponse.result) {
      firebaseLog.writeLog(databaseResponse.data.id + "  " + LogUtils.createdGame);
    }
    return databaseResponse.result;
  }

  Future getListComment(String postId) async {
    currComments.value = null;
    currComments.value = await firebaseGame.getComments(postId);
    currComments.value!.sort((a,b) => a.sendTime.compareTo(b.sendTime));
    currComments.refresh();
  }

  Future<GameComment?> addComment(String postId, String comment) async{
    try{
      GameComment? gameComment = await firebaseGame.addComment(postId, comment);
      currComments.value!.add(gameComment!);
      currComments.refresh();
      return gameComment;
    }catch(e){
      return null;
    }
  }

  Future addNewGame(GamePost gamePost) async{
    notFilteredList.add(gamePost);
    filterGameList("", null, null);
  }

  Future getMoreGames(String lastId) async{
    if(lastPulledPostCount == 10){
      await getGames(lastId);
      postList.refresh();
    }
  }

  void toggleLoading(bool toggleLoading){
    loading.value = toggleLoading;
    loading.refresh();
    print(loading);
  }
}
