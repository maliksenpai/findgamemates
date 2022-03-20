import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/data/firebase/firebase_log.dart';
import 'package:findgamemates/data/firebase/firebase_user.dart';
import 'package:findgamemates/model/login_request.dart';
import 'package:findgamemates/model/login_response.dart';
import 'package:findgamemates/utils/log_utils.dart';
import 'package:get/get.dart';

class UserGet extends GetxController {
  final FirebaseUser firebaseUser = Get.put(FirebaseUser());
  final FirebaseLog firebaseLog = Get.put(FirebaseLog());
  final UserDatabase userDatabase = Get.put(UserDatabase());

  Future<LoginResponse> loginUser(LoginRequest loginRequest) async {
    LoginResponse result = await firebaseUser.loginUser(loginRequest);
    if (result == LoginResponse.successful) {
      firebaseLog.writeLog(LogUtils.loginSuccess);
    } else {
      firebaseLog.writeLog(LogUtils.loginFailed);
    }
    return result;
  }

  Future<bool> logoutUser() async {
    bool logout = await firebaseUser.logoutUser();
    if (logout) {
      firebaseLog
          .writeLog(userDatabase.getUser()!.uid! + " - " + LogUtils.logoutUser);
      userDatabase.deleteUser();
    }
    return logout;
  }

  Future<bool> setUsername(String username) async {
    bool isSuccess = await firebaseUser.setUsername(username);
    if (isSuccess) {
      var user = userDatabase.getUser();
      user!.displayName = username;
      userDatabase.saveUser(user);
      await firebaseLog.writeLog(LogUtils.registerSuccess);
    }
    return isSuccess;
  }
}
