import 'package:findgamemates/screen/login_screen.dart';
import 'package:findgamemates/screen/main_screen.dart';
import 'package:findgamemates/screen/register_screen.dart';
import 'package:findgamemates/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Duration animationDuration = const Duration(seconds: 2);
  double height = 100;
  double width = 100;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      setState(() {
        height *= 2;
        width *= 2;
      });
      await checkLoggedUser();
    });
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: animationDuration,
          height: height,
          width: width,
          child: const FlutterLogo(

          ),
        ),
      ),
    );
  }

  Future checkLoggedUser() async{
    Future.delayed(const Duration(seconds: 1),(){
      var box = Hive.box("user");
      if(box.get("user") == null){
        RouteGenerator.newScreen(context, const LoginScreen());
      }else{
        RouteGenerator.newScreen(context, const MainScreen());
      }
    });
  }
}
