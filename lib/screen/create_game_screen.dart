import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_post.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/utils/dialog_utils.dart';
import 'package:findgamemates/utils/utils_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({Key? key}) : super(key: key);

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {

  GameGet gameGet = Get.put(GameGet());
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<GameType> gameTypeList = GameType.values;
  late GameType selectedGameType;
  List<String> gameProvinceList= UtilData.provienceList;
  late String selectedGameProvince;

  @override
  void initState() {
    selectedGameType = gameTypeList.first;
    selectedGameProvince = gameProvinceList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Oyun Yaratma"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll){
              overScroll.disallowGlow();
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/camping.png",
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2
                  ),
                  ListTile(
                    title: Text("Oyun ismi"),
                    trailing: SizedBox(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: TextField(
                        controller: titleController,
                        maxLines: 1,
                        maxLength: 20,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        const Expanded(
                          child: Text("Oyun açıklaması"),
                        ),
                        Expanded(
                          child: TextField(
                            controller: descController,
                            maxLines: 10,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1))
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                  ListTile(
                    title: Text("Oyun türü"),
                    trailing: DropdownButton(
                      value: selectedGameType,
                      onChanged: (GameType ?gameType){
                        setState(() {
                          selectedGameType = gameType!;
                        });
                      },
                      items: gameTypeList.map(
                            (e) => DropdownMenuItem(
                          child: Text(e == GameType.frp
                              ? "FRP"
                              : e == GameType.boardGame
                              ? "Kutu oyunu"
                              : e == GameType.tcg
                              ? "TCG"
                              : "Hata"),
                          value: e,
                        ),
                      ).toList(),
                    ),
                  ),
                  ListTile(
                    title: Text("Oyun Konumu"),
                    trailing: DropdownButton<String>(
                      value: selectedGameProvince,
                      onChanged: (String? gameProvince){
                        setState(() {
                          selectedGameProvince = gameProvince!;
                        });
                      },
                      items: gameProvinceList.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(),
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Oluştur",style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      //todo: check works normal?
                      DialogUtils.createLoadingDialog(context, "Yükleniyor", "Oyun oluşturuluyor");
                      if(titleController.text.isNotEmpty && descController.text.isNotEmpty){
                        await gameGet.createGame(titleController.text, descController.text, selectedGameProvince, selectedGameType);
                        //todo: add failed/success dialog
                        Navigator.of(Get.overlayContext!).pop();
                        Get.back();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
