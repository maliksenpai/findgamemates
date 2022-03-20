import 'package:findgamemates/model/app_user.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class UserDatabase extends GetxService {
  late Box userBox;

  @override
  void onInit() {
    userBox = Hive.box("user");
    super.onInit();
  }

  AppUser? getUser() {
    return userBox.get("loggedInUser", defaultValue: null);
  }

  void saveUser(AppUser? user) {
    userBox.put("loggedInUser", user);
  }

  void deleteUser() {
    userBox.delete("loggedInUser");
  }
}
