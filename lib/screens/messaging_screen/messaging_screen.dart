import 'package:flutter/material.dart';
import 'package:privateroom/utility/firebase_constants.dart';

class MessagingScreen extends StatefulWidget {
  final roomData;
  final password;

  MessagingScreen({
    @required this.roomData,
    @required this.password,
  });

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.roomData[kRoomName]),
      ),
    );
  }
}
