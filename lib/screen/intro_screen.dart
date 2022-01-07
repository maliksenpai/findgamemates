import 'dart:async';

import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/model/app_user.dart';
import 'package:findgamemates/screen/login_screen.dart';
import 'package:findgamemates/screen/main_screen.dart';
import 'package:findgamemates/screen/register_screen.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:findgamemates/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loading_indicator/loading_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  UserDatabase userDatabase = Get.put(UserDatabase());
  double height = 100;
  double width = 100;

  @override
  void initState() {
    checkLoggedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      setState(() {
        height *= 1.2;
        width *= 1.2;
      });
    });
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.6,
          child: LoadingIndicator(
            indicatorType: Indicator.ballTrianglePathColoredFilled,
            colors: [
              CustomThemeData.primaryColor,
              CustomThemeData.accentColor,
              CustomThemeData.cardColor
            ],
          ),
        ),
      ),
    );
  }

  Future checkLoggedUser() async{
    Timer(const Duration(seconds: 2),(){
      AppUser? user = userDatabase.getUser();
      if(user == null){
        RouteGenerator.newScreen(context, const LoginScreen());
      }else{
        RouteGenerator.newScreen(context, const MainScreen());
      }
    });
  }
}
