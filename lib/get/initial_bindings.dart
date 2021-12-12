import 'package:findgamemates/data/firebase/firebase_user.dart';
import 'package:findgamemates/get/game_get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => FirebaseUser());
    Get.lazyPut(() => GameGet());
  }

}