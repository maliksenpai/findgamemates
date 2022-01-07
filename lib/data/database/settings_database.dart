import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsDatabase extends GetxService{

  late Box applicationBox;

  @override
  void onInit() {
    applicationBox = Hive.box("settings");
    super.onInit();
  }

  bool isDarkMode(){
    return applicationBox.get("theme", defaultValue: false);
  }

  void changeTheme(bool bool){
    applicationBox.put("theme", bool);
  }

}