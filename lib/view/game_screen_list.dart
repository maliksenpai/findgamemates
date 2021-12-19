import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_post.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/screen/game_detail_screen.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameScreenList extends StatefulWidget {
  const GameScreenList({Key? key}) : super(key: key);

  @override
  _GameScreenListState createState() => _GameScreenListState();
}

class _GameScreenListState extends State<GameScreenList> {
  GameGet gameGet = Get.put(GameGet());

  @override
  Widget build(BuildContext context) {
    return Obx(
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
              color: CustomThemeData.cardColor,
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
                        Icon(
                          Icons.extension,
                          color: CustomThemeData.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          gameType,
                          style: const TextTheme().bodyText2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: CustomThemeData.accentColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          post.province,
                          style: const TextTheme().bodyText2,
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(() => GameDetailScreen(gamePost: post, key: UniqueKey(),));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
