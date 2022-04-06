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
            String fName = documentSnapshot.get(FieldPath(['firstName']));
            String lName = documentSnapshot.get(FieldPath(['lastName']));
            String phoneNum = documentSnapshot.get(FieldPath(['phoneNumber']));

            setState(() {
              Home.firstName = fName;
              Home.lastName = lName;
              Home.phoneNumber = phoneNum;
            });
          });

          print('exist');
        } else {
          print('doesnot exist');
          setState(() {
            Home.firstName = "Guest";
            Home.lastName = "";
            Home.phoneNumber = "No phone number";
          });
        }
      });
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
    );
  }
}