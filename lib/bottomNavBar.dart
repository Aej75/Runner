import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/account.dart';
import 'package:fyp2/home.dart';
import 'package:fyp2/map.dart';
import 'package:fyp2/stats.dart';
import 'functions/constants.dart';
import 'notification.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BottomNav();
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {


  final screens = [
    Home(),
    const Stats(),
    const MapSample(),
    const NotificationTab(),
    const Account(),
  ];

  late int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: kButtomNavIconColor,),label: "Home" , backgroundColor: kBackgroundColor),
          BottomNavigationBarItem(icon: Icon(Icons.assessment_rounded,color: kButtomNavIconColor),label: "Stats" , backgroundColor: kBackgroundColor),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run,color: kButtomNavIconColor),label: "Track" , backgroundColor: kBackgroundColor),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.bell,color: kButtomNavIconColor),label: "Notification" , backgroundColor: kBackgroundColor),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: kButtomNavIconColor),label: "Account" , backgroundColor: kBackgroundColor),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ) ,
    );
  }
}


