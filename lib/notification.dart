import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/functions/constants.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackgroundColor,
    );
  }
}
