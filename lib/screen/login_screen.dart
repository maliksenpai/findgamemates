import 'package:findgamemates/data/firebase/firebase_user.dart';
import 'package:findgamemates/model/login_request.dart';
import 'package:findgamemates/model/login_response.dart';
import 'package:findgamemates/screen/main_screen.dart';
import 'package:findgamemates/screen/register_screen.dart';
import 'package:findgamemates/utils/regex_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Ekranı"),),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: mailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.person),
                          labelText: "Mail Adresi",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Mail adresini boş bırakmayın";
                          }else{
                            if(GetUtils.isEmail(value)){
                              return null;
                            }else{
                              return "Lütfen geçerli bir mail adresi giriniz";
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 30,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: passController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          labelText: "Şifre",
                          prefixIcon: Icon(Icons.security),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        autocorrect: false,
                        obscureText: !_passwordVisible,
                        enableSuggestions: false,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Şifreyi boş bırakmayın";
                          }else{
                            if(RegexUtil.passwordRegex.hasMatch(value)){
                              return null;
                            }else{
                              return "Şifreniz yeterince güçlü değil";
                            }

                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      child: const Text("Giriş Yap"),
                      onPressed: () => attemptLogin(),
                    ),
                    SizedBox(height: 20,),
                    const Text("Eğer hesabınız yoksa otomatik olarak kayıt ekranına yönlendirileceksiniz",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> attemptLogin() async{
    if( _formKey.currentState!.validate()){
      FirebaseUser firebaseUser = Get.put(FirebaseUser());
      LoginResponse loginResponse = await firebaseUser.loginUser(LoginRequest(mail: mailController.text, passHash: passController.text));
      if(loginResponse == LoginResponse.successful){
        Get.offAll(const MainScreen());
      } else if(loginResponse == LoginResponse.userNotFound){
        Get.snackbar("Bilgi", "Kullanıcı bulunamadı, sizin için kayıt oluşturduk. Lütfen mail adresinizden hesabınızı aktif edin");
      } else if(loginResponse == LoginResponse.emailAlreadyUser){
        Get.snackbar("Hata", "Bu mail adresi zaten kullanılıyor");
      } else if(loginResponse == LoginResponse.weakPassword){
        Get.snackbar("Hata", "Zayıf Şifre");
      } else if(loginResponse == LoginResponse.none){
        Get.snackbar("Hata", "Hata oluştu");
      } else if(loginResponse == LoginResponse.emailNotVerified){
        Get.snackbar("Bilgi", "Hesap aktif değil, lütfen mail adresinizden hesabınızı aktif edin");
      } else if(loginResponse == LoginResponse.wrongPassword){
        Get.snackbar("Bilgi", "Yanlış Şifre");
      } else{
        Get.snackbar("Hata", "Hata oluştu");
      }
    }else{

    }
  }
}
