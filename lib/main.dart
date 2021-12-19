import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/get/initial_bindings.dart';
import 'package:findgamemates/model/app_user.dart';
import 'package:findgamemates/screen/games_screen.dart';
import 'package:findgamemates/screen/intro_screen.dart';
import 'package:findgamemates/screen/profile_screen.dart';
import 'package:findgamemates/screen/settings_screen.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/database/settings_database.dart';

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
  await Hive.openBox("settings");
  return;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsDatabase settingsDatabase = Get.put(SettingsDatabase());
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: InitialBindings(),
      routes: {
        '/games' : (context) => const GamesScreen(),
        '/settings' : (context) => const SettingsScreen(),
        'profile' : (context) => const ProfileScreen()
      },
      theme: settingsDatabase.isDarkMode() ? CustomThemeData().darkTheme : CustomThemeData().lightTheme,
      home: const IntroScreen(),
    );
  }
}
