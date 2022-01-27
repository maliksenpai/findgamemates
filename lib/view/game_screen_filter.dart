import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/utils_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class GameScreenFilter extends StatefulWidget {
  const GameScreenFilter({Key? key}) : super(key: key);

  @override
  _GameScreenFilterState createState() => _GameScreenFilterState();
}

class _GameScreenFilterState extends State<GameScreenFilter> {

  GameGet gameGet = Get.put(GameGet());
  List<GameType> gameTypeList = GameType.values;
  GameType? selectedGameType;
  List<String> gameProvinceList= ["Hepsi", ...UtilData.provienceList];
  String? selectedGameProvince;
  String currFilter = "";

  @override
  void initState() {
    super.initState();
  }

  void cupertinoGameTypeSelector(context){
    setState(() {
      selectedGameType = gameTypeList[0];
    });
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
                      : e == GameType.tcg
                      ? "TCG"
                      : "Hepsi"),
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
    ).then((value) => {
      gameGet.filterGameList(currFilter, selectedGameType, selectedGameProvince)
    });
  }

  void cupertinoProvienceSelector(){
    setState(() {
      selectedGameProvince = gameProvinceList[0];
    });
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
    ).then((value) => {
      gameGet.filterGameList(currFilter, selectedGameType, selectedGameProvince)
    });;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6,right: 6,top: 6),
          child: PlatformTextField(
            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            material: (_, __) => MaterialTextFieldData(
              decoration: const InputDecoration(
                  hintText: "Arama",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()
              ),
            ),
            cupertino: (_, __) => CupertinoTextFieldData(
              placeholder: "Arama",
              suffix: Icon(Icons.search)
            ),
            onChanged: (value){
              currFilter = value;
              gameGet.filterGameList(currFilter, selectedGameType, selectedGameProvince);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: PlatformWidget(
                    material: (_,__) =>DropdownButton<String?>(
                      hint: Text("Oyun lokasyonu"),
                      icon: Icon(Icons.location_on, color: CustomThemeData.accentColor,),
                      isExpanded: true,
                      value: selectedGameProvince,
                      onChanged: (String? gameProvince){
                        setState(() {
                          selectedGameProvince = gameProvince!;
                          gameGet.filterGameList(currFilter, selectedGameType, selectedGameProvince);
                        });
                      },
                      items: gameProvinceList.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(),
                    ),
                    cupertino: (_,__) => GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                child: Container(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  child: PlatformText(
                                    selectedGameProvince == null ? "Oyun Lokasyonu" : selectedGameProvince!,
                                  ),
                                ),
                              ),
                              Icon(Icons.location_on, color: CustomThemeData.accentColor,)
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                      onTap: () => cupertinoProvienceSelector()
                    ),
                  )
                ),
                VerticalDivider(),
                Expanded(
                  child: PlatformWidget(
                    material: (_, __) => DropdownButton<GameType?>(
                      isExpanded: true,
                      hint: Text("Oyun türü"),
                      icon: Icon(
                        Icons.extension,
                        color: CustomThemeData.primaryColor,
                      ),
                      value: selectedGameType,
                      onChanged: (GameType? gameType) {
                        setState(() {
                          selectedGameType = gameType!;
                          gameGet.filterGameList(currFilter, selectedGameType, selectedGameProvince);
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
                              : "Hepsi"),
                          value: e,
                        ),
                      ).toList(),
                    ),
                    cupertino: (_,__) => GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Material(
                                  child: Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    child: PlatformText(
                                        selectedGameType == null ?
                                        "Oyun Türü"
                                            :
                                        selectedGameType == GameType.frp
                                            ? "FRP"
                                            : selectedGameType == GameType.boardGame
                                            ? "Kutu oyunu"
                                            : selectedGameType == GameType.tcg
                                            ? "TCG"
                                            : "Hepsi"
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.extension,
                                  color: CustomThemeData.primaryColor,
                                )
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      onTap: () => cupertinoGameTypeSelector(context)
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
