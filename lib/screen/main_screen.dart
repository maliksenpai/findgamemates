import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/get/user_get.dart';
import 'package:findgamemates/screen/games_screen.dart';
import 'package:findgamemates/screen/profile_screen.dart';
import 'package:findgamemates/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{

  late TabController tabController;
  UserDatabase userDatabase = Get.put(UserDatabase());
  UserGet userGet = Get.put(UserGet());


  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.index = 1;
    super.initState();
    Future.delayed(Duration.zero,checkUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Masa Oyun M8'leri"),
        ),
        body: SafeArea(
          child: tabController.index == 0 ? const SettingsScreen() : tabController.index == 1 ? const GamesScreen() : const ProfileScreen()
        ),
        bottomNavigationBar: ConvexAppBar(
          controller: tabController,
          initialActiveIndex: 1,
          items: const [
            TabItem(icon: Icons.settings, title: "Ayarlar"),
            TabItem(icon: Icons.home, title: "Ana Ekran"),
            TabItem(icon: Icons.person, title: "Profil"),
          ],
          backgroundColor: Theme.of(context).primaryColor,
          onTap: (i){
            setState(() {
              tabController.index = i;
            });
          },
        ),
    );
  }


  void checkUsername(){
    if(userDatabase.getUser()!.displayName == null){
      TextEditingController controller = TextEditingController();
      bool isErrorShort = false;
      bool isErrorTaken = false;
      bool isSuccess = false;
      Get.dialog(
          StatefulBuilder(
            builder: (context, setState){
              return AlertDialog(
                title: Text("Eksik Kullanıcı Adı",style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/forget-password.png",
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const Text("Kullanıcı adınız henüz tanımlanmamış, lütfen kullanıcı adınızı giriniz"),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: "Kullanıcı Adı",
                          errorText: isErrorShort ?
                          "Kullanıcı adınız çok kısa" :
                          isErrorTaken ?
                          "Bu kullanıcı adı zaten kullanılıyor"
                              : null
                      ),
                    ),
                    const SizedBox(height: 20,),
                    isSuccess ? Text("İşlem başarılı",style: TextStyle(color: Colors.green),) : Container()
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if(controller.text.length<6){
                        setState((){
                          isErrorShort = true;
                        });
                      }else{
                        bool response = await userGet.setUsername(controller.text);
                        if(response){
                          setState((){
                            isErrorShort = false;
                            isErrorTaken = false;
                            isSuccess = true;
                          });
                          Future.delayed(Duration(seconds: 2),(){
                            Navigator.of(Get.overlayContext!).pop();
                          });
                        }else{
                          setState((){
                            isSuccess = false;
                            isErrorShort = false;
                            isErrorTaken = true;
                          });
                        }
                      }
                    },
                    child: const Text("Kaydet"),
                  )
                ],
              );
            },
          ),
        barrierDismissible: false
      );
    }
  }
}
