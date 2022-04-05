import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'functions/constants.dart';
import 'functions/tapped.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const stat();
  }
}

class stat extends StatefulWidget {
  const stat({Key? key}) : super(key: key);

  @override
  State<stat> createState() => _statState();
}

class _statState extends State<stat> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference details = FirebaseFirestore.instance.collection(
      (FirebaseAuth.instance.currentUser?.uid == null)
          ? "default"
          : FirebaseAuth.instance.currentUser!.uid);

  List itemList = [];
  List newList = [];

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

  @override
  void initState() {
    super.initState();
    fetchDetailList();
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

  specificUserDetail(context, index){
    if(newList[index]['user_ID'] == auth.currentUser){
      return Card(
        color: kBodyForegroundColor,
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
                          newList[index]['speed'].toString(),
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
                          newList[index]['time'].toString(),
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
                          newList[index]['steps'].toString(),
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: kBackgroundColor,
            body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    const SizedBox(
                      height: 50.0,
                      child: Center(
                          child: Text(
                            'Statistics',
                            style: TextStyle(color: kForegroundColor, fontSize: kBigFont),
                          )),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                        height: 500,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: newList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10.0,),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:5.0),
                                        child: Container(
                                          height: 22,
                                          width: 65,
                                          color: kBodyForegroundColor,
                                          child: Center(
                                            child: Text(
                                              newList[index]['currentDate'].toString(),
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  color: kForegroundColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:5.0),
                                        child: Container(
                                          height: 22,
                                          width: 45,
                                          color: kBodyForegroundColor,
                                          child: Center(
                                            child: Text(
                                              newList[index]['currentTime'].toString(),
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
                                    color: kBodyForegroundColor,
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
                                                      newList[index]['speed'].toString(),
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
                                                      newList[index]['time'].toString(),
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
                                                      newList[index]['steps'].toString(),
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
                                  const SizedBox(height: 10.0,)
                                ],
                              );
                            })),
                  ],
                )),
            // bottomNavigationBar: SizedBox(
            //   height: 60,
            //   child: BottomAppBar(
            //     color: kFooterColor,
            //     shape: const CircularNotchedRectangle(),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         TextButton(
            //           style: ButtonStyle(
            //               overlayColor:
            //               getColor(Colors.white, kTappedButtonColor)),
            //           onPressed: () {
            //             Navigator.pushNamed(context, '/home');
            //           },
            //           child: Column(
            //             children: const [
            //               Icon(
            //                 CupertinoIcons.home,
            //                 color: kForegroundColor,
            //               ),
            //               SizedBox(
            //                 height: 5.0,
            //               ),
            //               Text("Home", style: TextStyle(color: kForegroundColor))
            //             ],
            //           ),
            //         ),
            //         TextButton(
            //           style: ButtonStyle(
            //               overlayColor:
            //               getColor(Colors.white, kTappedButtonColor)),
            //           onPressed: () {},
            //           child: Column(
            //             children: const [
            //               Icon(
            //                 Icons.assessment_rounded,
            //                 color: kForegroundColor,
            //               ),
            //               SizedBox(
            //                 height: 5.0,
            //               ),
            //               Text("Stats", style: TextStyle(color: kForegroundColor))
            //             ],
            //           ),
            //         ),
            //         TextButton(
            //           style: ButtonStyle(
            //               overlayColor:
            //               getColor(Colors.white, kTappedButtonColor)),
            //           onPressed: () {
            //             Navigator.pushNamed(context, '/map');
            //           },
            //           child: Column(
            //             children: const [
            //               Icon(
            //                 Icons.directions_run,
            //                 color: kForegroundColor,
            //               ),
            //               SizedBox(
            //                 height: 5.0,
            //               ),
            //               Text("Track", style: TextStyle(color: kForegroundColor))
            //             ],
            //           ),
            //         ),
            //         TextButton(
            //           style: ButtonStyle(
            //               overlayColor:
            //               getColor(Colors.white, kTappedButtonColor)),
            //           onPressed: () {
            //             Navigator.pushNamed(context, '/notification');
            //           },
            //           child: Column(
            //             children: const [
            //               Icon(
            //                 CupertinoIcons.bell,
            //                 color: kForegroundColor,
            //               ),
            //               SizedBox(
            //                 height: 5.0,
            //               ),
            //               Text("Notification",
            //                   style: TextStyle(color: kForegroundColor))
            //             ],
            //           ),
            //         ),
            //         TextButton(
            //           style: ButtonStyle(
            //               overlayColor:
            //               getColor(Colors.white, kTappedButtonColor)),
            //           onPressed: () {},
            //           child: Column(
            //             children: const [
            //               Icon(
            //                 CupertinoIcons.person,
            //                 color: kForegroundColor,
            //               ),
            //               SizedBox(
            //                 height: 5.0,
            //               ),
            //               Text("Account",
            //                   style: TextStyle(color: kForegroundColor))
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
        ),
      ),
    );
  }
}
