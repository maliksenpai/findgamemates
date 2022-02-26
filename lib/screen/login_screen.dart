import 'package:findgamemates/get/user_get.dart';
import 'package:findgamemates/model/login_request.dart';
import 'package:findgamemates/model/login_response.dart';
import 'package:findgamemates/screen/main_screen.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/dialog_utils.dart';
import 'package:findgamemates/utils/regex_util.dart';
import 'package:findgamemates/view/login_text_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text("Giriş Ekranı",style: TextStyle(color: Colors.white),),
        material: (_, __) => MaterialAppBarData(
          elevation: 0
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: Border.all(width: 0, color: Theme.of(context).appBarTheme.backgroundColor!),
          brightness: Brightness.dark,
          transitionBetweenRoutes: true
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipPath(
                    clipper: WaveClipperTwo(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      color: Theme.of(context).appBarTheme.backgroundColor,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "Aslan Ağızı Hanı",
                          style: GoogleFonts.lobster(),
                        ),
                      ),
                    ),
                  ),
                  LoginTextArea(
                      mailController: mailController,
                      passwordController: passController,
                      passwordVisible: _passwordVisible,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlatformElevatedButton(
                        child: const Text("Giriş Yap"),
                        color: CustomThemeData.accentColor,
                        onPressed: () => attemptLogin(),
                        cupertino: (_,__) => CupertinoElevatedButtonData(
                          originalStyle: true
                        ),
                      ),
                      SizedBox(height: 20,),
                      Material(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Eğer hesabınız yoksa otomatik olarak kayıt ekranına yönlendirileceksiniz",
                            style: TextStyle(fontWeight: FontWeight.bold, color: CustomThemeData.primaryColor),
                          ),
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
                      color: Theme.of(context).appBarTheme.backgroundColor,
                    ),
                  )
                ],
              ),
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
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
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
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
    }
  }


}
