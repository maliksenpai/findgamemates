import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/model/app_user.dart';
import 'package:findgamemates/model/login_request.dart';
import 'package:findgamemates/model/login_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FirebaseUser extends GetxService {
  late DatabaseReference databaseReference;
  late CollectionReference collectionReference;
  late FirebaseAuth firebaseAuth;
  final UserDatabase userDatabase = Get.put(UserDatabase());

  @override
  void onInit() {
    collectionReference = FirebaseFirestore.instance.collection("users");
    databaseReference = FirebaseDatabase.instance.reference().child("users");
    firebaseAuth = FirebaseAuth.instance;
    super.onInit();
  }

  Future<LoginResponse> loginUser(LoginRequest loginRequest) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: loginRequest.mail,
              password: loginRequest.passwordHash.toString());
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          AppUser appUser = AppUser(
              uid: userCredential.user!.uid,
              displayName: userCredential.user!.displayName,
              email: userCredential.user!.email);
          userDatabase.saveUser(appUser);
          await saveDatabaseUser(appUser);
          return LoginResponse.successful;
        } else {
          sendVerification(userCredential.user);
          return LoginResponse.emailNotVerified;
        }
      } else {
        return LoginResponse.userNotFound;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return LoginResponse.weakPassword;
      } else if (e.code == "email-already-in-use") {
        return LoginResponse.emailAlreadyUser;
      } else if (e.code == "user-not-found") {
        registerUser(loginRequest);
        return LoginResponse.userNotFound;
      } else if (e.code == "wrong-password") {
        return LoginResponse.wrongPassword;
      } else {
        return LoginResponse.none;
      }
    }
  }

  Future<bool> registerUser(LoginRequest loginRequest) async {
    UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
            email: loginRequest.mail,
            password: loginRequest.passwordHash.toString());
    if (userCredential.user == null) {
      return false;
    } else {
      await sendVerification(userCredential.user);
      return true;
    }
  }

  Future<void> sendVerification(User? user) async {
    await user!.sendEmailVerification();
  }

  Future saveDatabaseUser(AppUser appUser) async {
    try {
      collectionReference.doc(appUser.uid.toString()).set(appUser.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> logoutUser() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setUsername(String username) async {
    try {
      //todo: check taken
      var checkTakenUsername = await collectionReference
          .where('displayName', isEqualTo: username)
          .get();
      if (checkTakenUsername.size == 0) {
        await firebaseAuth.currentUser?.updateDisplayName(username);
        await collectionReference
            .doc(firebaseAuth.currentUser!.uid.toString())
            .update({"displayName": username});
      } else {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
