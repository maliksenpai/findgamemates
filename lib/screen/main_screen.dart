import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:findgamemates/data/database/user_database.dart';
import 'package:findgamemates/get/user_get.dart';
import 'package:findgamemates/screen/games_screen.dart';
import 'package:findgamemates/screen/profile_screen.dart';
import 'package:findgamemates/screen/settings_screen.dart';
import 'package:findgamemates/theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController tabController;
  UserDatabase userDatabase = Get.put(UserDatabase());
  UserGet userGet = Get.put(UserGet());
  int iosTabBarIndex = 1;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.index = 1;
    super.initState();
    Future.delayed(Duration.zero, checkUsername);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text(
          "Aslan Ağızı Hanı",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        cupertino: (_, __) => CupertinoNavigationBarData(
          brightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
          child: tabController.index == 0
              ? const SettingsScreen()
              : tabController.index == 1
                  ? const GamesScreen()
                  : const ProfileScreen()),
      material: (_, __) => MaterialScaffoldData(
        bottomNavBar: ConvexAppBar(
          controller: tabController,
          initialActiveIndex: 1,
          items: const [
            TabItem(icon: Icons.settings, title: "Ayarlar"),
            TabItem(icon: Icons.home, title: "Ana Ekran"),
            TabItem(icon: Icons.person, title: "Profil"),
          ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          onTap: (i) {
            setState(() {
              tabController.index = i;
            });
          },
        ),
      ),
      cupertino: (_, __) => CupertinoPageScaffoldData(
        body: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            currentIndex: iosTabBarIndex,
            activeColor: CustomThemeData.accentColor,
            inactiveColor: Colors.white,
            onTap: (i) => setState(() {
              iosTabBarIndex = i;
            }),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Ayarlar"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Ana Ekran"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")
            ],
          ),
          tabBuilder: (context, index) {
            return iosTabBarIndex == 0
                ? const SettingsScreen()
                : iosTabBarIndex == 1
                    ? const GamesScreen()
                    : const ProfileScreen();
          },
        ),
      ),
    );
  }

  void checkUsername() {
    if (userDatabase.getUser()!.displayName == null) {
      TextEditingController controller = TextEditingController();
      bool isLoading = false;
      bool isErrorShort = false;
      bool isErrorTaken = false;
      bool isSuccess = false;
      Get.dialog(StatefulBuilder(
        builder: (context, setState) {
          return PlatformAlertDialog(
            title: Text(
              "Eksik Kullanıcı Adı",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/forget-password.png",
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    "Kullanıcı adınız henüz tanımlanmamış, lütfen kullanıcı adınızı giriniz"),
                const SizedBox(
                  height: 20,
                ),
                PlatformTextField(
                  controller: controller,
                  material: (_, __) => MaterialTextFieldData(
                    decoration: const InputDecoration(
                      labelText: "Kullanıcı Adı",
                    ),
                  ),
                  cupertino: (_, __) => CupertinoTextFieldData(
                    placeholder: "Kullanıcı Adı",
                  ),
                ),
                Text(
                  isErrorShort
                      ? "Kullanıcı adınız çok kısa"
                      : isErrorTaken
                          ? "Bu kullanıcı adı zaten kullanılıyor"
                          : "",
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 20,
                ),
                isSuccess
                    ? const Text(
                        "İşlem başarılı",
                        style: TextStyle(color: Colors.green),
                      )
                    : Container()
              ],
            ),
            actions: [
              PlatformTextButton(
                onPressed: () async {
                  if (controller.text.length < 6) {
                    setState(() {
                      isErrorShort = true;
                    });
                  } else if (isLoading) {
                  } else {
                    isLoading = true;
                    bool response = await userGet.setUsername(controller.text);
                    if (response) {
                      setState(() {
                        isErrorShort = false;
                        isErrorTaken = false;
                        isSuccess = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        isLoading = false;
                        Navigator.of(Get.overlayContext!, rootNavigator: true)
                            .pop();
                      });
                    } else {
                      setState(() {
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
      ), barrierDismissible: false);
    }
  }
}
