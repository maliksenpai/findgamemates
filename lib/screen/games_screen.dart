import 'package:findgamemates/get/game_get.dart';
import 'package:findgamemates/screen/create_game_screen.dart';
import 'package:findgamemates/view/game_screen_filter.dart';
import 'package:findgamemates/view/game_screen_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final GameGet gameGet = Get.put(GameGet());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          GameScreenFilter(),
          Expanded(
            child: GameScreenList(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => const CreateGameScreen());
        },
      ),
    );
  }
}
