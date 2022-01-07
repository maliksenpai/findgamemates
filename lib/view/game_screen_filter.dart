import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/model/game_types.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/utils_data.dart';
import 'package:flutter/material.dart';
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
  //todo : add "hepsi" element
  List<String> gameProvinceList= UtilData.provienceList;
  String? selectedGameProvince;
  String currFilter = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6,right: 6,top: 6),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Arama",
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder()
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
                  child: DropdownButton<String?>(
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
                ),
                VerticalDivider(),
                Expanded(
                  child: DropdownButton<GameType?>(
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
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
