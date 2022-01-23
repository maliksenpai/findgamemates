import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/regex_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class LoginTextArea extends StatefulWidget {
  TextEditingController mailController;
  TextEditingController passwordController;
  bool passwordVisible;

  LoginTextArea({required this.mailController, required this.passwordController, required this.passwordVisible});

  @override
  _LoginTextAreaState createState() => _LoginTextAreaState();
}

class _LoginTextAreaState extends State<LoginTextArea> {


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: PlatformTextFormField(
            controller: widget.mailController,
            material: (_, __) => MaterialTextFormFieldData(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: CustomThemeData.primaryColor),
                ),
                prefixIcon: Icon(Icons.person),
                labelText: "Mail Adresi",
              ),
            ),
            cupertino: (_, __) => CupertinoTextFormFieldData(
              decoration: BoxDecoration(
                border: Border.all(color: CustomThemeData.primaryColor,),
                borderRadius: BorderRadius.circular(12),
              ),
              prefix: Icon(Icons.person),
              placeholder: "Mail Adresi"
            ),
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
            keyboardType: TextInputType.emailAddress,

          ),
        ),
        const SizedBox(height: 30,),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: PlatformTextFormField(
            controller: widget.passwordController,
            material: (_, __) => MaterialTextFormFieldData(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: CustomThemeData.primaryColor)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: CustomThemeData.primaryColor),
                ),
                labelText: "Şifre",
                prefixIcon: const Icon(Icons.security),
                suffixIcon: IconButton(
                  icon: Icon(
                    widget.passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: CustomThemeData.accentColor,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.passwordVisible = !widget.passwordVisible;
                    });
                  },
                ),
              ),
            ),
            cupertino: (_, __) => CupertinoTextFormFieldData(
              decoration: BoxDecoration(
                border: Border.all(color: CustomThemeData.primaryColor,),
                borderRadius: BorderRadius.circular(12),
              ),
              prefix: Row(
                children: [
                  Icon(Icons.security),
                ],
              ),
              placeholder: "Şifre"
            ),
            autocorrect: false,
            obscureText: !widget.passwordVisible,
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
            }
          ),
        ),
      ],
    );
  }
}
