import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/functions/constants.dart';
import 'package:fyp2/functions/tapped.dart';
import 'package:fyp2/home.dart';
import 'package:fyp2/stats.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

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

  var bestSpeed;
  var bestDistance;
  var bestTime;

  Future getPersonalBest() async {
    var allList = [];
    var individualDistance = [];
    var individualSpeed = [];

    try {
      await details.get().then((value) => value.docs.forEach((element) {
            allList.add(element.data());
          }));
      print(allList);
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
      print(e);
      return null;
    }
  }

  void getIndividualDistance(List people, String personName) {
    // Find the index of person. If not found, index = -1
    final index = people.indexWhere((element) => element.name == personName);
    if (index >= 0) {
      print('Using indexWhere: ${people[index]}');
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPersonalBest(),
        builder: (context,data){
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
                    SizedBox(
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
                                color: kForegroundColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15.00,
                          ),
                          Text(
                            '${Home.phoneNumber} |  ${FirebaseAuth.instance.currentUser!.email}',
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
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 10, right: 10),
                          //   child: Column(
                          //     children: [
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Column(
                          //         children: [
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.person,
                          //                         size: 30,
                          //                         color: Colors.cyan,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Personal Information',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.doc_plaintext,
                          //                         size: 30,
                          //                         color: Colors.deepPurpleAccent,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Transaction Limit',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         Icons.account_balance_outlined,
                          //                         size: 30,
                          //                         color: Colors.blue,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Link Bank Account',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.settings,
                          //                         size: 30,
                          //                         color: Colors.deepOrange,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Settings',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.info,
                          //                         size: 30,
                          //                         color: Colors.purple,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'About Us',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       child: Icon(
                          //                         CupertinoIcons.question_diamond,
                          //                         size: 30,
                          //                         color: Colors.cyan,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Help and Support',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           Container(
                          //             height: 70.0,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(10),
                          //               color: Colors.blue.withOpacity(0.4),
                          //             ),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: const [
                          //                 Icon(CupertinoIcons.phone),
                          //                 Text(
                          //                   'Feel free to ask, we are ready to support.',
                          //                   style: TextStyle(fontWeight: FontWeight.w600),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           const SizedBox(height: 30.0),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: const [
                          //               Icon(Icons.logout),
                          //               SizedBox(
                          //                 width: 5.0,
                          //               ),
                          //               Text(
                          //                 'Log Out',
                          //                 style: TextStyle(
                          //                     color: Colors.red,
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.w600),
                          //               )
                          //             ],
                          //           ),
                          //           const SizedBox(height: 150.0)
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding:
                      EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
                                                '$bestSpeed kmph',
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
                                            children: const [
                                              Icon(
                                                CupertinoIcons.timer,
                                                size: 35,
                                                color: kIconColor,
                                              ),
                                              Text(
                                                '00:00 hr',
                                                style: TextStyle(
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
                                                '$bestDistance km',
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
                            ],
                          )
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 10, right: 10),
                          //   child: Column(
                          //     children: [
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Column(
                          //         children: [
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.person,
                          //                         size: 30,
                          //                         color: Colors.cyan,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Personal Information',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.doc_plaintext,
                          //                         size: 30,
                          //                         color: Colors.deepPurpleAccent,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Transaction Limit',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         Icons.account_balance_outlined,
                          //                         size: 30,
                          //                         color: Colors.blue,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Link Bank Account',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.settings,
                          //                         size: 30,
                          //                         color: Colors.deepOrange,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Settings',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       // color: Colors.blue,
                          //                       child: Icon(
                          //                         CupertinoIcons.info,
                          //                         size: 30,
                          //                         color: Colors.purple,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'About Us',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 80,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Row(
                          //                   children: const [
                          //                     SizedBox(
                          //                       height: 40,
                          //                       width: 40,
                          //                       child: Icon(
                          //                         CupertinoIcons.question_diamond,
                          //                         size: 30,
                          //                         color: Colors.cyan,
                          //                       ),
                          //                     ),
                          //                     SizedBox(width: 10),
                          //                     Text(
                          //                       'Help and Support',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 TextButton(
                          //                     onPressed: () {},
                          //                     child: const Icon(CupertinoIcons.forward))
                          //               ],
                          //             ),
                          //           ),
                          //           Container(
                          //             height: 70.0,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(10),
                          //               color: Colors.blue.withOpacity(0.4),
                          //             ),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: const [
                          //                 Icon(CupertinoIcons.phone),
                          //                 Text(
                          //                   'Feel free to ask, we are ready to support.',
                          //                   style: TextStyle(fontWeight: FontWeight.w600),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           const SizedBox(height: 30.0),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: const [
                          //               Icon(Icons.logout),
                          //               SizedBox(
                          //                 width: 5.0,
                          //               ),
                          //               Text(
                          //                 'Log Out',
                          //                 style: TextStyle(
                          //                     color: Colors.red,
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.w600),
                          //               )
                          //             ],
                          //           ),
                          //           const SizedBox(height: 150.0)
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else{
            return const SafeArea(
                child: Scaffold(
                  backgroundColor: kBackgroundColor,
                  body: Center(child: CircularProgressIndicator()),
                ));
          }
        });
  }
}
