import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/dialog_utils.dart';
import 'package:findgamemates/utils/utils_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
  List<GameType> gameTypeList = GameType.values.sublist(1,4);
  late GameType selectedGameType;
  List<String> gameProvinceList= UtilData.provienceList;
  late String selectedGameProvince;

  @override
  void initState() {
    selectedGameType = gameTypeList.first;
    selectedGameProvince = gameProvinceList.first;
    super.initState();
  }

  void cupertinoGameTypeSelector(context){
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          color: Colors.white,
          width: 300,
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.2,
          child: CupertinoPicker(
            itemExtent: 30,
            children: gameTypeList.map(
                  (e) => DropdownMenuItem(
                child: Center(
                  child: Text(e == GameType.frp
                      ? "FRP"
                      : e == GameType.boardGame
                      ? "Kutu oyunu"
                      : "TCG"),
                ),
                value: e,
              ),
            ).toList(),
            onSelectedItemChanged: (int index) {
              setState(() {
                selectedGameType = gameTypeList[index];
              });
            },
          ),
        )
    );
  }

  void cupertinoProvienceSelector(){
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          color: Colors.white,
          width: 300,
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.4,
          child: CupertinoPicker(
            itemExtent: 30,
            children: gameProvinceList.map((e) => Center(child: Text(e))).toList(),
            onSelectedItemChanged: (int index) {
              setState(() {
                selectedGameProvince = gameProvinceList[index];
              });
            },
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {


    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Oyun Yaratma",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        cupertino: (_, __) => CupertinoNavigationBarData(
            brightness: Brightness.dark,
            backgroundColor: Theme.of(context).brightness == Brightness.light ? CustomThemeData.primaryColor : Colors.black
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll){
              overScroll.disallowGlow();
              return true;
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
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              alignment: Alignment.center,
                              child: PlatformText("Oyun ismi",)
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: PlatformTextField(
                            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                            controller: titleController,
                            maxLines: 1,
                            maxLength: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                            child: Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                alignment: Alignment.center,
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: PlatformText("Oyun açıklaması"),
                            )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: PlatformTextField(
                            controller: descController,
                            maxLines: 10,
                            maxLength: 500,
                            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                            material: (_, __) => MaterialTextFieldData(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1))
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              alignment: Alignment.center,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: PlatformText("Oyun türü"),
                          ),
                        ),
                        PlatformWidget(
                          material: (_, __) => Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            child: DropdownButton(
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
                          cupertino: (_, __) => GestureDetector(
                            child: Material(
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                                child: Text(selectedGameType == GameType.frp
                                    ? "FRP"
                                    : selectedGameType == GameType.boardGame
                                    ? "Kutu oyunu"
                                    : selectedGameType == GameType.tcg
                                    ? "TCG"
                                    : "Hata"),
                              ),
                            ),
                            onTap: () => cupertinoGameTypeSelector(context) ,
                          )
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.4,
                          alignment: Alignment.center,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: PlatformText("Oyun Konumu"),
                        ),
                      ),
                      PlatformWidget(
                        material:(_, __) => Container(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: DropdownButton<String>(
                            value: selectedGameProvince,
                            onChanged: (String? gameProvince){
                              setState(() {
                                selectedGameProvince = gameProvince!;
                              });
                            },
                            items: gameProvinceList.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(),
                          ),
                        ),
                        cupertino: (_,__) => GestureDetector(
                          child: Material(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                              child: Text(selectedGameProvince),
                            ),
                          ),
                          onTap: () => cupertinoProvienceSelector() ,
                        )
                      )
                    ],
                  ),
                  SizedBox(height:20,),
                  PlatformElevatedButton(
                    child: Text("Oluştur",style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),),
                    color: Theme.of(context).colorScheme.secondary,
                    cupertino: (_, __) => CupertinoElevatedButtonData(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    onPressed: () async {
                      DialogUtils.createLoadingDialog(context, "Yükleniyor", "Oyun oluşturuluyor");
                      if(titleController.text.isNotEmpty && descController.text.isNotEmpty){
                        bool result = await gameGet.createGame(titleController.text, descController.text, selectedGameProvince, selectedGameType);
                        if(result){
                          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                          Get.back();
                        }else{
                          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                          Get.snackbar("Hata", "Bir hata oluştu");
                        }
                      }else{
                        Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                        Get.snackbar("Hata", "Gerekli bilgileri doldurunuz lütfen");
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
