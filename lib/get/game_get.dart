import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/data/firebase/firebase_game.dart';
import 'package:findgamemates/data/firebase/firebase_log.dart';
import 'package:findgamemates/model/database_response.dart';
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

  @override
  void onInit() async {
    if (postList.value.isEmpty) {
      postList.value = await firebaseGame.getGameList(null, null, null);
      notFilteredList.addAll(postList.value);
    }
    super.onInit();
  }

  void filterGameList(String filter, GameType? gameType, String? province) {
    postList.value = notFilteredList.where((element) =>
    (element.gameType == gameType || gameType == null) &&
        (element.title.contains(filter) || element.desc.contains(filter)) &&
        (element.province == province || province == null)
    ).toList();
    /*postList.value = notFilteredList.where((element) {
      bool a1 = element.gameType == gameType;
      bool a2 = (element.title.contains(filter) || element.desc.contains(filter));
      bool a3 = element.province == province;
      return a1 && a2 && a3;
    }).toList();*/

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
}
