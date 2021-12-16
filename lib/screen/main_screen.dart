import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:findgamemates/screen/games_screen.dart';
import 'package:findgamemates/screen/profile_screen.dart';
import 'package:findgamemates/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{

  late TabController tabController;


  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.index = 1;
    super.initState();
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


}
