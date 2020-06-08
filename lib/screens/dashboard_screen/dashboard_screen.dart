import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/screens/dashboard_screen/foreground_screen.dart';
import 'package:privateroom/screens/messaging_screen/messaging_screen.dart';
import 'package:privateroom/services/encryption_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void navBarOnPressed() {}

  @override
  Widget build(BuildContext context) {
    var backgroundScreen = Container(
      color: kWhite,
    );

    return Container(
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          backgroundScreen,
          ForegroundScreen(
            navBarOnPressed: navBarOnPressed,
          ),
        ],
      ),
    );
  }
}
