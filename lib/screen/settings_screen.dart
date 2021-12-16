import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:findgamemates/data/database/settings_database.dart';
import 'package:findgamemates/get/user_get.dart';
import 'package:findgamemates/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  SettingsDatabase settingsDatabase = Get.put(SettingsDatabase());
  UserGet userGet = Get.put(UserGet());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Ayarlar",
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 22),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Karanlık Mod"),
            trailing: DayNightSwitcher(
              isDarkModeEnabled: settingsDatabase.isDarkMode(),
              onStateChanged: (bool bool){
                setState(() {
                  settingsDatabase.changeTheme(bool);
                  Get.changeTheme(bool ? ThemeData.dark() : ThemeData.light());
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Çıkış Yap"),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent
                ),
                onPressed: () async {
                    Get.dialog(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          CircularProgressIndicator(),
                          Text("Çıkış Yapılıyor")
                        ],
                      ),
                      barrierDismissible: false
                    );
                    bool logout = await userGet.logoutUser();
                    Navigator.of(Get.overlayContext!).pop();
                    if(logout){
                      Get.off(const LoginScreen());
                    }else{
                      Get.snackbar("İşlem Başarısız", "Çıkış işlemi başarısız oldu");
                    }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
