import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/model/app_user.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late AppUser? appUser;
  UserDatabase userDatabase = Get.put(UserDatabase());


  @override
  void initState() {
    super.initState();
    appUser = userDatabase.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height*0.4,
              maxHeight: MediaQuery.of(context).size.height*0.4,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  CustomThemeData.primaryColor,
                  CustomThemeData.accentColor
                ]
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.elliptical(500,200),
                bottomRight: Radius.elliptical(500,200)
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Profil Ekranı",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 60,
                  child: Icon(
                    Icons.person,
                    color: CustomThemeData.cardColor,
                    size: 100,
                  ),
                  backgroundColor: Colors.white,
                )
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height*0.4,
              maxHeight: MediaQuery.of(context).size.height*0.4,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text("Kullanıcı Adı", style: TextStyle(fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Divider(thickness: 2, color: CustomThemeData.primaryColor,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: CustomThemeData.primaryColor,),
                          SizedBox(width: 10,),
                          Text(appUser!.displayName!)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text("Mail Adres", style: TextStyle(fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Divider(thickness: 2, color: CustomThemeData.primaryColor,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mail, color: CustomThemeData.primaryColor,),
                          SizedBox(width: 10,),
                          Text(appUser!.email!)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
