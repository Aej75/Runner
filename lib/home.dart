import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/stats.dart';
import 'functions/constants.dart';
import 'functions/tapped.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  static late String firstName = "";
  static late String lastName = "";
  static late String phoneNumber = "";
  static late String highestDistance = "";

  static Map distanceData = {};

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


  getName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      try {
        String fName = documentSnapshot.get(FieldPath(['firstName']));
        String lName = documentSnapshot.get(FieldPath(['lastName']));
        String phoneNum = documentSnapshot.get(FieldPath(['phoneNumber']));

        setState(() {
          Home.firstName = fName;
          Home.lastName = lName;
          Home.phoneNumber = phoneNum;

        });
      } on StateError catch (e) {
        print('No nested field exists!');
      }
    });
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  // specificUserDetail(context, index){
  //   if(newList[index]['user_ID'] == auth.currentUser){
  //     return Card(
  //       color: kBodyForegroundColor,
  //       child: SizedBox(
  //         height: 75,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         newList[index]['speed'].toString(),
  //                         style: const TextStyle(
  //                             fontSize: kBigFont,
  //                             color: kForegroundColor),
  //                       ),
  //                       const SizedBox(
  //                         height: 5,
  //                       ),
  //                       const Text(
  //                         'Top Speed',
  //                         style: TextStyle(
  //                             fontSize: kSmallStatFont,
  //                             color: kForegroundColor),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         newList[index]['distance']
  //                             .toString(),
  //                         style: const TextStyle(
  //                             fontSize: kBigFont,
  //                             color: kForegroundColor),
  //                       ),
  //                       const SizedBox(
  //                         height: 5,
  //                       ),
  //                       const Text(
  //                         'Total Distance',
  //                         style: TextStyle(
  //                             fontSize: kSmallStatFont,
  //                             color: kForegroundColor),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         newList[index]['time'].toString(),
  //                         style: const TextStyle(
  //                             fontSize: kBigFont,
  //                             color: kForegroundColor),
  //                       ),
  //                       const SizedBox(
  //                         height: 5,
  //                       ),
  //                       const Text(
  //                         'Total Time',
  //                         style: TextStyle(
  //                             fontSize: kSmallStatFont,
  //                             color: kForegroundColor),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         newList[index]['steps'].toString(),
  //                         style: const TextStyle(
  //                             fontSize: kBigFont,
  //                             color: kForegroundColor),
  //                       ),
  //                       const SizedBox(
  //                         height: 5,
  //                       ),
  //                       const Text(
  //                         'Total steps',
  //                         style: TextStyle(
  //                             fontSize: kSmallStatFont,
  //                             color: kForegroundColor),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 // Text(newList[index]['distance'].toString()),
  //                 // Text(newList[index]['speed'].toString()),
  //                 // Text(newList[index]['time']),
  //                 // checkUserId(context, index),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: kBaseColor,
          appBar: AppBar(
            // leading: IconButton(
            //     onPressed: () {
            //       FirebaseAuth.instance.signOut();
            //       Navigator.pushNamed(context, '/');
            //     },
            //     icon: const Icon(Icons.logout)),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/');
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
                          style:
                              TextStyle(fontSize: 70, color: kForegroundColor)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Start Running',
                              style: TextStyle(
                                  fontSize: 20, color: kForegroundColor)),
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
                              color: kForegroundColor, fontSize: kBigFont)),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Welcome to the runner app',
                        style: TextStyle(
                            color: kForegroundColor, fontSize: kSmallFont),
                      )
                    ],
                  ),
                ),

                // ElevatedButton(
                //   onPressed: (){
                //     buildButtons;
                //   },
                //   style: ElevatedButton.styleFrom(primary: kBodyForegroundColor,elevation: 0.0,shadowColor: Colors.transparent),
                //   child: const Center(
                //     child: Text(
                //       'Start',
                //       style: TextStyle(color: Colors.white, fontSize: 17.0),
                //     ),
                //   ),
                // ),
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
                              color: kForegroundColor, fontSize: kBigFont)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 105,
                  width: double.infinity,
                  color: kBodyForegroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Water",
                            style: TextStyle(
                                color: kForegroundColor, fontSize: kSmallFont)),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          '0 glasses',
                          style: TextStyle(
                              color: kForegroundColor, fontSize: kBigFont),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// bottomNavigationBar: SizedBox(
// height: 60,
// child: BottomAppBar(
// color: kFooterColor,
// shape: const CircularNotchedRectangle(),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// TextButton(
// style: ButtonStyle(
// overlayColor:
// getColor(Colors.white, kTappedButtonColor)),
// onPressed: () {},
// child: Column(
// children: const [
// Icon(
// CupertinoIcons.home,
// color: kForegroundColor,
// ),
// SizedBox(
// height: 5.0,
// ),
// Text("Home", style: TextStyle(color: kForegroundColor))
// ],
// ),
// ),
// TextButton(
// style: ButtonStyle(
// overlayColor:
// getColor(Colors.white, kTappedButtonColor)),
// onPressed: () {
// Navigator.pushNamed(context, '/stats');
// },
// child: Column(
// children: const [
// Icon(
// Icons.assessment_rounded,
// color: kForegroundColor,
// ),
// SizedBox(
// height: 5.0,
// ),
// Text("Stats", style: TextStyle(color: kForegroundColor))
// ],
// ),
// ),
// TextButton(
// style: ButtonStyle(
// overlayColor:
// getColor(Colors.white, kTappedButtonColor)),
// onPressed: () {
// Navigator.pushNamed(context, '/map');
// },
// child: Column(
// children: const [
// Icon(
// Icons.directions_run,
// color: kForegroundColor,
// ),
// SizedBox(
// height: 5.0,
// ),
// Text("Track", style: TextStyle(color: kForegroundColor))
// ],
// ),
// ),
// TextButton(
// style: ButtonStyle(
// overlayColor:
// getColor(Colors.white, kTappedButtonColor)),
// onPressed: () {},
// child: Column(
// children: const [
// Icon(
// CupertinoIcons.bell,
// color: kForegroundColor,
// ),
// SizedBox(
// height: 5.0,
// ),
// Text("Notification",
// style: TextStyle(color: kForegroundColor))
// ],
// ),
// ),
// TextButton(
// style: ButtonStyle(
// overlayColor:
// getColor(Colors.white, kTappedButtonColor)),
// onPressed: () {},
// child: Column(
// children: const [
// Icon(
// CupertinoIcons.person,
// color: kForegroundColor,
// ),
// SizedBox(
// height: 5.0,
// ),
// Text("Account",
// style: TextStyle(color: kForegroundColor))
// ],
// ),
// ),
// ],
// ),
// ),
// ),
