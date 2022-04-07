import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'functions/constants.dart';
import 'functions/tapped.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const noti();
  }
}

class noti extends StatefulWidget {
  const noti({Key? key}) : super(key: key);

  @override
  State<noti> createState() => _notiState();
}

class _notiState extends State<noti> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference details =
      FirebaseFirestore.instance.collection('notification');

  List itemList = [];
  List newList = [];

  late String _notiTitle = "";
  late String _notiMessage = "";

  //then((value) => value.docs.forEach((element) {
  //         itemList.add(element.data());
  //       }));

  Future getDetails() async {
    try {
      FirebaseFirestore.instance
          .collection('notification')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document exist on the database');
          String title = documentSnapshot.get(FieldPath(['nUsername']));
          String message = documentSnapshot.get(FieldPath(['welcomeMessage']));

          setState(() {
            _notiTitle = title;
            _notiMessage = message;
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
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
            "Notification",
            style: TextStyle(color: kForegroundColor),
          ),
          backgroundColor: kBackgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    color: kBodyForegroundColor,
                    child: SizedBox(
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    _notiTitle,
                                    style: const TextStyle(
                                        fontSize: kBigFont,
                                        color: kForegroundColor),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _notiMessage,
                                    style: const TextStyle(
                                        fontSize: kSmallStatFont,
                                        color: kForegroundColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
