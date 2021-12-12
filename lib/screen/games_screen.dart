import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_post.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/screen/create_game_screen.dart';
import 'package:findgamemates/screen/game_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late List<GamePost> list = [];
  GameGet gameGet = Get.put(GameGet());

  @override
  void initState() {
    if (kDebugMode) {
      //todo: mock data
      list.add(GamePost(id: "asd", createrId: "asd", createTime: "12312313", title: "asd", desc: "sdfs", gameType: GameType.frp, province: "Ankara", active: true));
      list.add(GamePost(id: "asd", createrId: "asd", createTime: "12312313", title: "asd", desc: "sdfs", gameType: GameType.frp, province: "Ankara", active: true));
      list.add(GamePost(id: "asd", createrId: "asd", createTime: "12312313", title: "asd", desc: "sdfs", gameType: GameType.frp, province: "Ankara", active: true));
      list.add(GamePost(id: "asd", createrId: "asd", createTime: "12312313", title: "asd", desc: "sdfs", gameType: GameType.frp, province: "Ankara", active: true));
      list.add(GamePost(id: "asd", createrId: "asd", createTime: "12312313", title: "asd", desc: "sdfs", gameType: GameType.frp, province: "Ankara", active: true));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("sad"),
          Expanded(
              child: Obx(
            () => ListView.builder(
              itemCount: gameGet.postList.value.length,
              itemBuilder: (context, index) {
                GamePost post = gameGet.postList.value[index];
                String gameType = post.gameType == GameType.frp
                    ? "FRP"
                    : post.gameType == GameType.boardGame
                        ? "Kutu oyunu"
                        : post.gameType == GameType.tcg
                            ? "TCG"
                            : "Hata";
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text(post.title),
                      subtitle: Text(
                        post.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.extension, size: 20,),
                              SizedBox(width: 4,),
                              Text(
                                gameType,
                                style: const TextTheme().bodyText2,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, size: 20,),
                              SizedBox(width: 4,),
                              Text(
                                post.province,
                                style: const TextTheme().bodyText2,
                              ),
                            ],
                          ),

                        ],
                      ),
                      onTap: (){
                        Get.to(() => GameDetailScreen());
                      },
                    ),
                  ),
                );
              },
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(() => const CreateGameScreen());
        },
      ),
    );
  }
}
