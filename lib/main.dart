import 'package:findgamemates/get/initial_bindings.dart';
import 'package:findgamemates/model/app_user.dart';
import 'package:findgamemates/screen/games_screen.dart';
import 'package:findgamemates/screen/intro_screen.dart';
import 'package:findgamemates/screen/profile_screen.dart';
import 'package:findgamemates/screen/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  registerAdapters();
  await initHiveBoxes();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  InitialBindings().dependencies();
  runApp(const MyApp());
}

void registerAdapters(){
  Hive.registerAdapter(AppUserAdapter());
}

Future initHiveBoxes() async{
  await Hive.initFlutter();
  await Hive.openBox("user");
  return;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: InitialBindings(),
      routes: {
        '/games' : (context) => GamesScreen(),
        '/settings' : (context) => SettingsScreen(),
        'profile' : (context) => ProfileScreen()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroScreen(),
    );
  }
}
