import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_comment.dart';
import 'package:findgamemates/view/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameDetailComments extends StatefulWidget {
  String gamePostId;

  GameDetailComments({Key? key, required this.gamePostId}) : super(key: key);

  @override
  _GameDetailCommentsState createState() => _GameDetailCommentsState();
}

class _GameDetailCommentsState extends State<GameDetailComments> {
  List<GameComment>? comments;
  GameGet gameGet = Get.put(GameGet());

  @override
  void initState() {
    gameGet.getListComment(widget.gamePostId);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    gameGet.getListComment(widget.gamePostId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (gameGet.currComments.value == null) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(strokeWidth: 4,),
        );
      } else {
        if (gameGet.currComments.value!.isEmpty) {
          return Container();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: gameGet.currComments.value!.length,
            itemBuilder: (context, index) {
              return CommentWidget(
                gameComment: gameGet.currComments.value![index],
              );
            },
          );
        }
      }
    });
  }
}
