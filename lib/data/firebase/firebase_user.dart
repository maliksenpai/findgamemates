import 'dart:math';
import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/model/login_request.dart';
import 'package:findgamemates/model/login_response.dart';
import 'package:findgamemates/model/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FirebaseUser extends GetxService{

  late DatabaseReference databaseReference;
  late FirebaseAuth firebaseAuth;
  UserDatabase userDatabase = Get.put(UserDatabase());

  @override
  void onInit() {
    databaseReference = FirebaseDatabase.instance.reference().child("users");
    firebaseAuth = FirebaseAuth.instance;
    super.onInit();
  }

  Future<LoginResponse> loginUser(LoginRequest loginRequest) async{
    try{
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: loginRequest.mail, password: loginRequest.passwordHash.toString());
      if(userCredential.user != null){
        if(userCredential.user!.emailVerified){
          AppUser appUser = AppUser(uid: userCredential.user!.uid, displayName: userCredential.user!.displayName, email: userCredential.user!.email);
          userDatabase.saveUser(appUser);
          await saveDatabaseUser(appUser);
          return LoginResponse.successful;
        }else{
          sendVerification(userCredential.user);
          return LoginResponse.emailNotVerified;
        }
      }else{
        return LoginResponse.userNotFound;
      }
    } on FirebaseAuthException catch (e){
      if(e.code == "weak-password"){
        return LoginResponse.weakPassword;
      } else if(e.code == "email-already-in-use"){
        return LoginResponse.emailAlreadyUser;
      } else if (e.code == "user-not-found"){
        registerUser(loginRequest);
        return LoginResponse.userNotFound;
      } else if(e.code == "wrong-password"){
        return LoginResponse.wrongPassword;
      } else{
        return LoginResponse.none;
      }
    }
  }

  Future<bool> registerUser(LoginRequest loginRequest) async{
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: loginRequest.mail, password: loginRequest.passwordHash.toString());
    if(userCredential.user == null){
      return false;
    }else{
      await sendVerification(userCredential.user);
      return true;
    }
  }

  Future<void> sendVerification(User? user) async{
    await user!.sendEmailVerification();
  }


  Future saveDatabaseUser(AppUser appUser) async {
    databaseReference.child(appUser.uid.toString()).set(appUser.toJson());
  }


  Future<bool> logoutUser() async{
    try{
      await firebaseAuth.signOut();
      return true;
    }catch (e){
      return false;
    }
  }
}
