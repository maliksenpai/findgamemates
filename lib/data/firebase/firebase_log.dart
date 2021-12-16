import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FirebaseLog extends GetxService{

  late DatabaseReference databaseReference;
  late FirebaseAuth firebaseAuth;

  @override
  void onInit() {
    databaseReference = FirebaseDatabase.instance.reference().child("logs");
    firebaseAuth = FirebaseAuth.instance;
    super.onInit();
  }

  Future writeLog(String log) async {
    User? user = firebaseAuth.currentUser;
    if(user != null){
      String dateTime = DateTime.now().toUtc().toString();
      String userId = user.uid;
      String logResult = userId + "  -  " + dateTime + "  -  " + log;
      databaseReference.push().set(logResult);
    }
  }

}