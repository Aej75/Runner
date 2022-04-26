import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp2/notification.dart';
import 'account.dart';
import 'functions/constants.dart';
import 'main.dart';

class Home extends StatefulWidget {
  static late String firstName = "";
  static late String lastName = "";
  static late String phoneNumber = "";
  static late String highestDistance = "";
  static bool Noti = true;
  static Map distanceData = {};
  static late String changeInBestDistance = "";

  static late String title = "";
  static late String description = "";
  static late int glass;

  //

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // CollectionReference details = FirebaseFirestore.instance.collection(
  //     (FirebaseAuth.instance.currentUser?.uid == null)
  //         ? "notiDefault"
  //         : 'noti${FirebaseAuth.instance.currentUser!.uid}');
  //
  // void addNotiDetails() async {
  //   if (Home.Noti == true) {
  //     await details
  //         .add({
  //           'Title': Home.title,
  //           'Description': Home.description,
  //         })
  //         .then((value) => print('successfully added'))
  //         .catchError((error) {
  //           print('$error');
  //         });
  //   }
  // }
  //
  // checkBestSpeed() {
  //   if (bestSpeed == null) {
  //     return null;
  //   } else {
  //     Home.title = 'Top Speed';
  //     Home.description = 'Your top personal best speed is $bestSpeed';
  //   }
  // }

  checkBestDistance() {
    if (Account.bestDistance == null) {
      return null;
    } else {
      Home.title = 'Best Distance';
      Home.description = 'Your top personal best distance is $bestDistance';
    }
  }

  getUserName() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid == null ? "default" : auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          String fName = documentSnapshot.get(FieldPath(const ['firstName']));
          String lName = documentSnapshot.get(FieldPath(const ['lastName']));
          String phoneNum =
              documentSnapshot.get(FieldPath(const ['phoneNumber']));

          setState(() {
            Home.firstName = fName;
            Home.lastName = lName;
            Home.phoneNumber = phoneNum;
          });
        });

        print('exist');
      } else {
        print('does not exist');
        setState(() {
          Home.firstName = "Guest";
          Home.lastName = "";
          Home.phoneNumber = "No phone number";
        });
      }
    });
  }

  storeAndCheckWelcomeMessage() async {
    FirebaseFirestore.instance
        .collection('WelcomeNotification')
        .doc(auth.currentUser?.uid == null ? "default" : auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (auth.currentUser?.uid == null) {
        var firebaseUser = 'default';
        await FirebaseFirestore.instance
            .collection("WelcomeNotification")
            .doc(firebaseUser)
            .set({
          'nUsername': 'Hello ${Home.firstName}',
          'welcomeMessage': 'Welcome To the Runner App'
        });
      } else {
        var firebaseUser = auth.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection("WelcomeNotification")
            .doc(firebaseUser)
            .set({
          'nUsername': 'Hello ${Home.firstName}',
          'welcomeMessage': 'Welcome To the Runner App'
        });
        print('stored');
      }
    });
  }

  bool isSelected = true;

  late int bestSpeed;
  late int bestDistance;
  var bestTime;
  var allList = [];
  var titleList = [];

  Future getPersonalBest() async {
    var individualDistance = [];
    var individualSpeed = [];

    try {
      await FirebaseFirestore.instance
          .collection((FirebaseAuth.instance.currentUser?.uid == null)
              ? "default"
              : FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) => value.docs.forEach((element) {
                allList.add(element.data());
              }));

      for (int i = 0; i < allList.length; i++) {
        individualDistance.add(allList[i]["distance"]);
        individualSpeed.add(allList[i]["speed"]);
      }
      bestDistance = (individualDistance
          .reduce((value, element) => value > element ? value : element));
      bestSpeed = (individualSpeed
          .reduce((value, element) => value > element ? value : element));
      return allList;
    } catch (e) {
      print('error = $e');
    }
  }

  storeAndCheckTopSpeed() async {
    FirebaseFirestore.instance
        .collection(auth.currentUser?.uid == null
            ? "notiDefault"
            : auth.currentUser!.uid)
        .doc()
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (auth.currentUser?.uid == 'default') {
        await FirebaseFirestore.instance.collection('notiDefault').doc().set({
          'Title': 'Top Speed',
          'Description': 'Your best Speed is ${bestSpeed}'
        });
        await FirebaseFirestore.instance.collection('notiDefault').doc().set({
          'Title': 'Top Distance',
          'Description': 'Your best distance is${bestDistance}'
        });
      } else {
        await FirebaseFirestore.instance
            .collection('noti${auth.currentUser!.uid}')
            .doc()
            .set({
          'Title': 'Top Speed',
          'Description': 'Your best Speed is ${bestSpeed} Kmph'
        });
        await FirebaseFirestore.instance
            .collection('noti${auth.currentUser!.uid}')
            .doc()
            .set({
          'Title': 'Top Distance',
          'Description': 'Your best distance is ${bestDistance} meter'
        });
      }
    });
  }

  var data = [];

  Future deleteDuplicateData() async {
    var collectionPath = (FirebaseAuth.instance.currentUser?.uid == null)
        ? "notiDefault"
        : 'noti${FirebaseAuth.instance.currentUser!.uid}';
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .get()
        .then((value) => value.docs.forEach((element) {
              titleList.add(element.data());
            }));

    for (int i = 0; i < titleList.length - 1; i++) {
      if (titleList[i]['Description'] ==
          titleList[i < titleList.length ? i + 1 : titleList.length]
              ['Description']) {
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .get()
            .then((value) => value.docs.forEach((element) {
                  data.add(element.data());
                }));
      }
    }
    print(data);
  }

  @override
  void initState() {
    checkDateAndAddWater();
    getCurrentTAD();
    deleteDuplicateData();
    getUserName();
    getPersonalBest();
    Future.delayed(const Duration(seconds: 1), () {
      storeAndCheckWelcomeMessage();
    });
    Future.delayed(const Duration(seconds: 2), () {
      showNotification();
      storeAndCheckTopSpeed();
    });
    super.initState();
  }




  showNotification() {
    if (Home.Noti == true) {
      flutterLocalNotificationsPlugin.show(
          0,
          "Hello ${Home.firstName}",
          "Welcome to the Runner App",
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  importance: Importance.high,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher')));
      setState(() {
        Home.Noti = false;
      });
    } else {
      return null;
    }
  }


  addGlass() {
    if(Home.glass >=0) {
      setState(() {
        Home.glass++;
    });
    }
  }

  // getGlass() {
  //   FirebaseFirestore.instance
  //       .collection(auth.currentUser?.uid == null ? "default" : auth.currentUser!.uid)
  //       .doc()
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       FirebaseFirestore.instance
  //           .collection(auth.currentUser?.uid == null ? "default" : auth.currentUser!.uid)
  //           .doc()
  //           .get()
  //           .then((DocumentSnapshot documentSnapshot) {
  //         int glass = documentSnapshot.get(FieldPath(const ['glass']));
  //         print(glass);
  //
  //         setState(() {
  //
  //         });
  //       });
  //
  //       print('water exist');
  //     } else {
  //       print('water does not exist');
  //       // setState(() {
  //       //   Home.firstName = "Guest";
  //       //   Home.lastName = "";
  //       //   Home.phoneNumber = "No phone number";
  //       // });
  //     }
  //   });
  // }

  late String _currentDate;


  getCurrentTAD() {
    DateTime now = DateTime.now();

    _currentDate =
        '${now.year.toString()}-${now.month.toString()}-${now.day.toString()}';
  }


  Future checkDateAndAddWater()async{
    Future.delayed(const Duration(seconds: 0), () async {
      await details
          .doc(_currentDate)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          details
              .doc(_currentDate)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            int totalGlass = documentSnapshot.get(FieldPath(const ['glass']));
            setState(() {
              Home.glass = totalGlass;
            });
          });
        } else {
          setState(() {
            Home.glass = 0;
          });
        }
      });
    })
        .then((value) => print('successfully added ${Home.glass} in database'))
        .catchError((error) {
      print('$error');
    });
  }

  CollectionReference details = FirebaseFirestore.instance.collection(
      (FirebaseAuth.instance.currentUser?.uid == null)
          ? "waterDefault"
          : 'water${FirebaseAuth.instance.currentUser!.uid}');

  void addWater() {
    if (Home.glass > 0) {
      Future.delayed(const Duration(seconds: 1), () async {
        await details.doc().get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            details.doc(_currentDate).update({'glass': Home.glass, 'currentDate': _currentDate});
          } else {
            details.doc(_currentDate).set({'glass': Home.glass,'currentDate': _currentDate});
          }
        });
      })
          .then((value) => print('successfully added ${Home.glass} in database'))
          .catchError((error) {
        print('$error');
      });
    }
  }

  minusGlass() {
    setState(() {
      if (Home.glass > 0) {
        Home.glass--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder(
            future: Future.wait([getPersonalBest()]),
            builder: (context, data) {
              if (data.hasData) {
                return Scaffold(
                  backgroundColor: kBaseColor,
                  appBar: AppBar(
                    actions: [
                      IconButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushNamed(context, '/');
                            Home.firstName = "";
                            Home.lastName = "";
                            Home.phoneNumber = "";
                            setState(() {
                              Home.Noti = true;
                            });
                          },
                          icon: const Icon(Icons.logout))
                    ],
                    automaticallyImplyLeading: false,
                    backgroundColor: kBackgroundColor,
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 450,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Runner',
                                  style: TextStyle(
                                      fontSize: 70, color: kForegroundColor)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Start Running',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: kForegroundColor)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    'images/runner.png',
                                    width: 40.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 105,
                          width: double.infinity,
                          color: kBodyForegroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Dear, ${Home.firstName} ${Home.lastName}',
                                  style: const TextStyle(
                                      color: kForegroundColor,
                                      fontSize: kBigFont)),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text(
                                'Welcome to the runner app',
                                style: TextStyle(
                                    color: kForegroundColor,
                                    fontSize: kSmallFont),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 80,
                          width: double.infinity,
                          color: kBodyForegroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Additional Features",
                                  style: TextStyle(
                                      color: kForegroundColor,
                                      fontSize: kBigFont)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 160,
                          width: double.infinity,
                          color: kBodyForegroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Water",
                                    style: TextStyle(
                                        color: kForegroundColor,
                                        fontSize: kSmallFont)),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${Home.glass} glasses',
                                      style: const TextStyle(
                                          color: kForegroundColor,
                                          fontSize: kBigFont),
                                    ),
                                    const SizedBox(
                                      width: 180.0,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                            height: 40,
                                            child: FloatingActionButton(
                                              onPressed: () {
                                                addGlass();
                                                addWater();
                                              },
                                              backgroundColor:
                                                  kBodyForegroundColor,
                                              child: Icon(CupertinoIcons.plus),
                                            )),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                            height: 40,
                                            child: FloatingActionButton(
                                              onPressed: () {
                                                addWater();
                                                minusGlass();
                                              },
                                              backgroundColor:
                                                  kBodyForegroundColor,
                                              child: Icon(CupertinoIcons.minus),
                                            )),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
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
                      bottomNavigationBar: LinearProgressIndicator()),
                );
              }
            }));
  }
}
