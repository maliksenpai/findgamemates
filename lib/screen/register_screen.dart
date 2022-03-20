import 'package:findgamemates/data/firebase/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final FirebaseUser firebaseUser = Get.put(FirebaseUser());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Ekranı"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text("Mail adresiniz üzerinden gelen kodu lütfen giriniz!"),
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Doğrulama Kodu",
                  counterText: "",
                ),
                maxLength: 12,
              ),
              ElevatedButton(
                  child: const Text("Gönder"),
                  onPressed: () => attempMailVerification())
            ],
          ),
        ),
      ),
    );
  }

  Future<void> attempMailVerification() async {
    if (textEditingController.text.isNotEmpty) {
      //var isSuccessful = firebaseUser.sendMailVerification(textEditingController.text);

    }
  }
}
