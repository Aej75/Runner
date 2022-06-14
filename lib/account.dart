import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/functions/constants.dart';
import 'package:fyp2/home.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  static var bestSpeed;
  static var bestDistance;
  static var bestTime;
  static var email;

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    getPersonalBest();
    super.initState();
  }

  @override
  late String speed = "";
  late String time = "";

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference details = FirebaseFirestore.instance.collection(
      (FirebaseAuth.instance.currentUser?.uid == null)
          ? "default"
          : FirebaseAuth.instance.currentUser!.uid);

  Future getPersonalBest() async {
    var allList = [];
    var individualDistance = [];
    var individualSpeed = [];

    try {
      await details.get().then((value) => value.docs.forEach((element) {
            allList.add(element.data());
          }));

      for (int i = 0; i < allList.length; i++) {
        individualDistance.add(allList[i]["distance"]);
        individualSpeed.add(allList[i]["speed"]);
      }
      Account.email = FirebaseAuth.instance.currentUser?.email == null
          ? "No Email"
          : FirebaseAuth.instance.currentUser?.email;

      Account.bestDistance = (individualDistance
          .reduce((value, element) => value > element ? value : element));
      Account.bestSpeed = (individualSpeed
          .reduce((value, element) => value > element ? value : element));

      return allList;
    } catch (e) {
      print(e);
    }
  }


  void getIndividualDistance(List people, String personName) {
    // Find the index of person. If not found, index = -1
    final index = people.indexWhere((element) => element.name == personName);
    if (index >= 0) {
      print('Using indexWhere: ${people[index]}');
    }
  }

  late String value;

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPersonalBest(),
        builder: (context, data) {
          if (data.hasData) {
            return Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: AppBar(
                elevation: 0.00,
                centerTitle: true,
                title: const Text(
                  "Account",
                  style: TextStyle(color: kForegroundColor),
                ),
                backgroundColor: kBackgroundColor,
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: kBodyForegroundColor,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30.00,
                          ),
                          Container(
                            // color: Colors.red,
                            height: 100,
                            width: 100,
                            child: const Icon(Icons.account_circle,
                                size: 100, color: kIconColor),
                          ),
                          const SizedBox(
                            height: 15.00,
                          ),
                          Text(
                            '${Home.firstName} ${Home.lastName}',
                            style: const TextStyle(
                                color: kForegroundColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15.00,
                          ),
                          Text(
                            '${Home.phoneNumber} |  ${Account.email}',
                            style: const TextStyle(color: kForegroundColor),
                          ),
                          const SizedBox(
                            height: 15.00,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Add bio",
                              style: TextStyle(color: kForegroundColor),
                            ),
                          ),
                          const SizedBox(
                            height: 15.00,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      color: kBodyForegroundColor,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Best',
                            style: TextStyle(
                                color: kForegroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Column(
                            children: [
                              Container(
                                height: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      color: kForeForegroundColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.speedometer,
                                            size: 35,
                                            color: kIconColor,
                                          ),
                                          Text(
                                            '${Account.bestSpeed} kmph',
                                            style: const TextStyle(
                                                fontSize: kMediumFont,
                                                fontWeight: FontWeight.bold,
                                                color: kForegroundColor),
                                          )
                                        ],
                                      ),
                                    )),
                                    const SizedBox(width: 5),
                                    Expanded(
                                        child: Container(
                                      color: kForeForegroundColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.directions_run_sharp,
                                            size: 35,
                                            color: kIconColor,
                                          ),
                                          Text(
                                            '${Account.bestDistance / 1000} km',
                                            style: const TextStyle(
                                                fontSize: kMediumFont,
                                                fontWeight: FontWeight.bold,
                                                color: kForegroundColor),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 150,
                              ),
                              GestureDetector(
                                onTap: (){
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushNamed(context, '/');
                                  Home.firstName = "";
                                  Home.lastName = "";
                                  Home.phoneNumber = "";
                                  setState(() {
                                    Home.Noti = true;
                                  });
                                },
                                child: Container(
                                  color: kForeForegroundColor,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: kSmallFont,
                                            color: kForegroundColor),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SafeArea(
              child: Scaffold(
                  backgroundColor: kBackgroundColor,
                  bottomNavigationBar: Text('No data')),
            );
          }
        });
  }
}
