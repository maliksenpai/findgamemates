import 'package:findgamemates/get/user_get.dart';
import 'package:findgamemates/model/login_request.dart';
import 'package:findgamemates/model/login_response.dart';
import 'package:findgamemates/screen/main_screen.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/dialog_utils.dart';
import 'package:findgamemates/utils/regex_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  UserGet userGet = Get.put(UserGet());

  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Giriş Ekranı"), elevation: 0,),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    color: CustomThemeData.primaryColor,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Aslan Ağızı Hanı",
                      style: GoogleFonts.lobster(),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: mailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: CustomThemeData.primaryColor),
                          ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: CustomThemeData.primaryColor)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: CustomThemeData.primaryColor),
                          ),
                          labelText: "Şifre",
                          prefixIcon: Icon(Icons.security),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: CustomThemeData.accentColor,
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      child: const Text("Giriş Yap"),
                      onPressed: () => attemptLogin(),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "Eğer hesabınız yoksa otomatik olarak kayıt ekranına yönlendirileceksiniz",
                        style: TextStyle(fontWeight: FontWeight.bold, color: CustomThemeData.primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                ClipPath(
                  clipper: WaveClipperTwo(reverse: true),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    color: CustomThemeData.primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> attemptLogin() async{
    DialogUtils.createLoadingDialog(context, "Yükleniyor", "Uygulamaya giriş yapılmaya çalışılıyor");
    if( _formKey.currentState!.validate()){
      LoginResponse loginResponse = await userGet.loginUser(LoginRequest(mail: mailController.text, passHash: passController.text));
      Navigator.of(Get.overlayContext!).pop();
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
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
