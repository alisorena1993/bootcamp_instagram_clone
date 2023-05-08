import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tec/gen/assets.gen.dart';
import 'package:tec/res/colors.dart';
import 'package:tec/route/names.dart';
import 'package:tec/screens/mainscreen/explore_screen.dart';
import 'package:tec/screens/mainscreen/home_screen.dart';
import 'package:tec/screens/mainscreen/notrifications_screen.dart';
import 'package:tec/screens/mainscreen/user_profile_screen.dart';

final GlobalKey<NavigatorState> _homeScreenKey = GlobalKey();
final GlobalKey<NavigatorState> _explorScreenKey = GlobalKey();
final GlobalKey<NavigatorState> _notifiyScreenKey = GlobalKey();
final GlobalKey<NavigatorState> _profileScreenKey = GlobalKey();

Map bottomNavKeys = {
  BottomNavIndex.homeIndex: _homeScreenKey,
  BottomNavIndex.explorIndex: _explorScreenKey,
  BottomNavIndex.notifyIndex: _notifiyScreenKey,
  BottomNavIndex.userProfileIndex: _profileScreenKey
};

List indexStackList = [];

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int selectedIndex = 0;

class _MainScreenState extends State<MainScreen> {
  Future<bool> _onWillPop() async {
    bool quittheapp = false;
    if (bottomNavKeys[indexStackList.last].currentState!.canPop()) {
      bottomNavKeys[indexStackList.last].currentState!.pop();
    } else if (indexStackList.length > 1) {
      setState(() {
        selectedIndex = indexStackList.last;
      });
      indexStackList.removeLast();
    } else {
      await showDialog(
          context: context,
          builder: (context) => Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Quit the app?",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.075),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                quittheapp = true;
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.white),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                quittheapp = false;
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              child: const Text(
                                "No",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
    }

    return quittheapp;
  }

  @override
  void initState() {
    indexStackList = [0];
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 60,
                child: IndexedStack(
                  index: indexStackList.last,
                  children: [
                    Navigator(
                      key: _homeScreenKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    ),
                    Navigator(
                      key: _explorScreenKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => const ExploreScreen()),
                    ),
                    Navigator(
                      key: _notifiyScreenKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => const NotificationsScreen()),
                    ),
                    Navigator(
                      key: _profileScreenKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => const UserProfileScreen()),
                    ),
                  ],
                ),
              ),
              Positioned(bottom: 0, left: 0, right: 0, child: btmNav(context))
            ],
          ),
        ),
      ),
    );
  }

  Container btmNav(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      color: MyColors.bottomNavigationBar,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: (() => setState(() {
                    indexStackList.add(BottomNavIndex.homeIndex);
                  })),
              icon: indexStackList.last == BottomNavIndex.homeIndex
                  ? Assets.icons.homeSelected.svg()
                  : Assets.icons.home.svg()),
          IconButton(
              onPressed: (() => setState(() {
                    indexStackList.add(BottomNavIndex.explorIndex);
                  })),
              icon: indexStackList.last == BottomNavIndex.explorIndex
                  ? Assets.icons.exploreSelected.svg()
                  : Assets.icons.explore.svg()),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, Screens.addNew),
              icon: Assets.icons.addNew.svg()),
          IconButton(
              onPressed: (() => setState(() {
                    indexStackList.add(BottomNavIndex.notifyIndex);
                  })),
              icon: indexStackList.last == BottomNavIndex.notifyIndex
                  ? Assets.icons.notifySelected.svg()
                  : Assets.icons.notify.svg()),
          IconButton(
              onPressed: (() => setState(() {
                    indexStackList.add(BottomNavIndex.userProfileIndex);
                  })),
              icon: indexStackList.last == BottomNavIndex.userProfileIndex
                  ? const Icon(Icons.verified_user_sharp)
                  : const Icon(Icons.verified_user_outlined)),
        ],
      ),
    );
  }
}

class BottomNavIndex {
  BottomNavIndex._();
  static const int homeIndex = 0;
  static const int explorIndex = 1;
  static const int notifyIndex = 2;
  static const int userProfileIndex = 3;
}
