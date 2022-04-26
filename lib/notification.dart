import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'account.dart';
import 'functions/constants.dart';
import 'functions/tapped.dart';
import 'home.dart';

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

  CollectionReference details = FirebaseFirestore.instance.collection(
      (FirebaseAuth.instance.currentUser?.uid == null)
          ? "notiDefault"
          : 'noti${FirebaseAuth.instance.currentUser!.uid}');

  List itemList = [];
  List newList = [];

  late String _notiTitle = "";
  late String _notiMessage = "";


  //then((value) => value.docs.forEach((element) {
  //         itemList.add(element.data());
  //       }));

  Future getWelcomeDetails() async {
    try {
      FirebaseFirestore.instance
          .collection('WelcomeNotification')
          .doc(FirebaseAuth.instance.currentUser?.uid == null
          ? 'default'
          : FirebaseAuth.instance.currentUser!.uid)
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
          print(_notiTitle + _notiMessage);
        } else {
          print('Document does not exist on the database');
        }
      });
    } catch (e) {
      print(e);
      return null;
    }
  }




  Future getAllNotification() async {
    try {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser?.uid == null
          ? 'notiDefault'
          : 'noti${FirebaseAuth.instance.currentUser!.uid}')
          .get().then((value) => itemList.forEach((element) {
        itemList.add(element.data());
      }));
      print(itemList);
      return itemList;
    } catch (e) {
      print(e);
      return null;
    }
  }
  @override
  void initState() {

    getWelcomeDetails();
    getAllNotification();
    fetchDetailList();
    super.initState();
  }

  fetchDetailList() async {
    dynamic resultant = await getAllNotification();

    if (resultant == null) {
      if (kDebugMode) {
        print('Unable to retrieve');
      }
    } else {
      setState(() {
        newList = resultant;
        print(newList);
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

  getTopSpeed(){

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
          child: Card(
            color: kWaterColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_notiTitle $_notiMessage',
                                style: const TextStyle(
                                    fontSize: kSmallFont,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff002c2b)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
