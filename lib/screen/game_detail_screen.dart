import 'package:findgamemates/model/game_post.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/view/game_detail_comments.dart';
import 'package:findgamemates/view/game_detail_input.dart';
import 'package:flutter/material.dart';

class GameDetailScreen extends StatefulWidget {

  GamePost gamePost;

  GameDetailScreen({Key? key, required this.gamePost}) : super(key: key);

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {

  late String gameType;

  @override
  void initState() {
    gameType = widget.gamePost.gameType == GameType.frp
        ? "FRP"
        : widget.gamePost.gameType == GameType.boardGame
        ? "Kutu oyunu"
        : widget.gamePost.gameType == GameType.tcg
        ? "TCG"
        : "Hata";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    gameType = widget.gamePost.gameType == GameType.frp
        ? "FRP"
        : widget.gamePost.gameType == GameType.boardGame
        ? "Kutu oyunu"
        : widget.gamePost.gameType == GameType.tcg
        ? "TCG"
        : "Hata";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: AppBar(title: Text(widget.gamePost.title),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll){
              overScroll.disallowGlow();
              return false;
            },
            child: ListView(
              children: [
                Text(
                  widget.gamePost.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Divider(),
                Card(
                  elevation: 12,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.gamePost.desc,
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.extension,
                                    color: Theme.of(context).primaryColor,
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
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    widget.gamePost.province,
                                    style: const TextTheme().bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  elevation: 12,
                  child: GameDetailComments(gamePostId: widget.gamePost.id, key: UniqueKey(),),
                ),
                Card(
                  elevation: 12,
                  child: GameDetailInput(postId: widget.gamePost.id,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
