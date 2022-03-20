import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/regex_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class LoginTextArea extends StatefulWidget {
  final TextEditingController mailController;
  final TextEditingController passwordController;

  const LoginTextArea(
      {Key? key, required this.mailController,
      required this.passwordController}) : super(key: key);

  @override
  _LoginTextAreaState createState() => _LoginTextAreaState();
}

class _LoginTextAreaState extends State<LoginTextArea> {

  bool passwordVisible = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: PlatformTextFormField(
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            controller: widget.mailController,
            material: (_, __) => MaterialTextFormFieldData(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: CustomThemeData.primaryColor),
                ),
                prefixIcon: const Icon(Icons.person),
                labelText: "Mail Adresi",
              ),
            ),
            cupertino: (_, __) => CupertinoTextFormFieldData(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CustomThemeData.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefix: const Icon(Icons.person),
                placeholder: "Mail Adresi"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Mail adresini boş bırakmayın";
              } else {
                if (GetUtils.isEmail(value)) {
                  return null;
                } else {
                  return "Lütfen geçerli bir mail adresi giriniz";
                }
              }
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: PlatformTextFormField(
              controller: widget.passwordController,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
              material: (_, __) => MaterialTextFormFieldData(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: CustomThemeData.primaryColor)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: CustomThemeData.primaryColor),
                      ),
                      labelText: "Şifre",
                      prefixIcon: const Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: CustomThemeData.accentColor,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
              cupertino: (_, __) => CupertinoTextFormFieldData(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CustomThemeData.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefix: GestureDetector(
                    child: Icon(
                      passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  placeholder: "Şifre"),
              autocorrect: false,
              obscureText: !passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Şifreyi boş bırakmayın";
                } else {
                  if (RegexUtil.passwordRegex.hasMatch(value)) {
                    return null;
                  } else {
                    return "Şifreniz yeterince güçlü değil";
                  }
                }
              }),
        ),
      ],
    );
  }
}
