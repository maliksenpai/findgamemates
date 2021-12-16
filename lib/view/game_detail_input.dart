import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameDetailInput extends StatefulWidget {

  String postId;

  GameDetailInput({Key? key, required this.postId}) : super(key: key);

  @override
  _GameDetailInputState createState() => _GameDetailInputState();
}

class _GameDetailInputState extends State<GameDetailInput> {

  TextEditingController inputController = TextEditingController();
  GameGet gameGet = Get.put(GameGet());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: inputController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Yorum",
                  border: OutlineInputBorder()
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                //todo:add validation
                Get.defaultDialog(
                  title: "Yükleniyor",
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      CircularProgressIndicator(),
                      Text("Yorum Ekleniyor")
                    ],
                  ),
                  barrierDismissible: false
                );
                GameComment? comment = await gameGet.addComment(widget.postId, inputController.text);
                Navigator.of(Get.overlayContext!).pop();
                if(comment == null){
                  Get.snackbar("İşlem başarısız", "Yorum gönderilemedi");
                }else{
                  inputController.clear();
                }
              },
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor,),
            ),
          )
        ],
      ),
    );
  }
}
