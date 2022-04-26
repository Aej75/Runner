import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/home.dart';
import 'functions/constants.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stat();
  }
}

class Stat extends StatefulWidget {
  const Stat({Key? key}) : super(key: key);

  @override
  State<Stat> createState() => _StatState();
}

class _StatState extends State<Stat> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference details = FirebaseFirestore.instance.collection(
      (FirebaseAuth.instance.currentUser?.uid == null)
          ? "default"
          : FirebaseAuth.instance.currentUser!.uid);

  List itemList = [];
  List newList = [];
  List waterList = [];
  List glassList = [];

  Future getDetails() async {
    try {
      await details.get().then((value) => value.docs.forEach((element) {
            itemList.add(element.data());
          }));
      return itemList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getWaterDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection((FirebaseAuth.instance.currentUser?.uid == null)
              ? "waterDefault"
              : 'water${FirebaseAuth.instance.currentUser!.uid}')
          .get()
          .then((value) => value.docs.forEach((element) {
                waterList.add(element.data());
              }));
      print(waterList);
      return waterList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetailList();
    fetchWaterDetails();
  }

  fetchWaterDetails() async {
    dynamic resultant = await getWaterDetails();

    if (resultant == null) {
      if (kDebugMode) {
        print('Unable to retrieve');
      }
    } else {
      setState(() {
        glassList = resultant;
      });
    }
  }

  fetchDetailList() async {
    dynamic resultant = await getDetails();

    if (resultant == null) {
      if (kDebugMode) {
        print('Unable to retrieve');
      }
    } else {
      setState(() {
        newList = resultant;
      });
    }
  }

  checkUserId(context, index) {
    if (newList[index]['user_ID'] == null) {
      return const Text('No User ID');
    } else {
      return Text(newList[index]['user_ID']);
    }
  }

  Widget glass(index) {
    if (newList[index]['currentDate'] ==
        FirebaseFirestore.instance
            .collection('water${FirebaseAuth.instance.currentUser!.uid}')
            .doc(newList[index]['currentDate'])
            .id) {
      return Card(
        color: kBodyForegroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 90.0,
            child: Column(
              children: [
                Text(
                  Home.glass.toString(),
                  style: const TextStyle(
                      fontSize: kBigFont, color: kForegroundColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Glass',
                  style: TextStyle(
                      fontSize: kSmallStatFont, color: kForegroundColor),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 0.00,
          centerTitle: true,
          title: const Text(
            "Statistics",
            style: TextStyle(color: kForegroundColor),
          ),
          backgroundColor: kBackgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                  height: 400,
                  color: kStatsBackGroundColor,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: newList.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      height: 22,
                                      width: 65,
                                      color: kIconColor2,
                                      child: Center(
                                        child: Text(
                                          newList[index]['currentDate']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: kForegroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      height: 22,
                                      width: 45,
                                      color: kIconColor,
                                      child: Center(
                                        child: Text(
                                          newList[index]['currentTime']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: kForegroundColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Card(
                                color: kStatsForeGroundColor,
                                child: SizedBox(
                                  height: 75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  newList[index]['speed']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: kBigFont,
                                                      color: kForegroundColor),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Top Speed',
                                                  style: TextStyle(
                                                      fontSize: kSmallStatFont,
                                                      color: kForegroundColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  newList[index]['distance']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: kBigFont,
                                                      color: kForegroundColor),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Total Distance',
                                                  style: TextStyle(
                                                      fontSize: kSmallStatFont,
                                                      color: kForegroundColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  newList[index]['time']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: kBigFont,
                                                      color: kForegroundColor),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Total Time',
                                                  style: TextStyle(
                                                      fontSize: kSmallStatFont,
                                                      color: kForegroundColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  newList[index]['steps']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: kBigFont,
                                                      color: kForegroundColor),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Total steps',
                                                  style: TextStyle(
                                                      fontSize: kSmallStatFont,
                                                      color: kForegroundColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Text(newList[index]['distance'].toString()),
                                          // Text(newList[index]['speed'].toString()),
                                          // Text(newList[index]['time']),
                                          // checkUserId(context, index),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                  color: kWaterColor,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: glassList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      height: 22,
                                      width: 65,
                                      color: kIconColor2,
                                      child: Center(
                                        child: Text(
                                          glassList[index]['currentDate']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: kForegroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Card(
                                color: kForeWaterColor,
                                child: SizedBox(
                                  height: 75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Column(
                                              children: [
                                                Text(
                                                  glassList[index]['glass']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: kBigFont,
                                                      color: kWaterTextColor),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Glass',
                                                  style: TextStyle(
                                                      fontSize: kSmallStatFont,
                                                      fontWeight: FontWeight.bold,
                                                      color: kForegroundColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'You drank ${glassList[index]['glass'].toString()} glass of water',
                                              style: const TextStyle(
                                                  fontSize: kSmallFont,
                                                  fontWeight: FontWeight.bold,
                                                  color: kBodyForegroundColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
