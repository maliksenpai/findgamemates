import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findgamemates/utils/log_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FirebaseLog extends GetxService {
  late DatabaseReference databaseReference;
  late CollectionReference collectionReference;
  late FirebaseAuth firebaseAuth;

  @override
  void onInit() {
    collectionReference = FirebaseFirestore.instance.collection("logs");
    firebaseAuth = FirebaseAuth.instance;
    super.onInit();
  }

  Future writeLog(String log) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        String dateTime = DateTime.now().toUtc().toString();
        String userId = user.uid;
        String logResult = userId + "  -  " + dateTime + "  -  " + log;
        //databaseReference.push().set(logResult);
        collectionReference.add({"log": logResult});
      }
    } catch (e) {
      writeLog(LogUtils.databaseError + e.toString());
    }
  }
}
