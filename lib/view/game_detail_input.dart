import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
              child: PlatformTextField(
                controller: inputController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                material: (_, __) => MaterialTextFieldData(
                  decoration: const InputDecoration(
                      hintText: "Yorum",
                      border: OutlineInputBorder()
                  ),
                ),
                cupertino: (_, __) => CupertinoTextFieldData(
                  placeholder: "Yorum"
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                if(!inputController.text.isEmpty){
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
                }else{
                  Get.snackbar("İşlem başarısız", "Yorum boş gönderilemez");
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
