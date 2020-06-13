import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/screens/messaging_screen/widgets/floating_button.dart';
import 'package:privateroom/screens/messaging_screen/webview_screen.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';

class MessagingScreen extends StatefulWidget {
  final roomData;
  final password;
  final name;

  MessagingScreen({
    @required this.roomData,
    @required this.password,
    @required this.name,
  });

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  bool showWebScreen = true;
  var _documentRef;

  @override
  void initState() {
    super.initState();

    _documentRef = Firestore.instance
        .collection(kChatCollection)
        .document(widget.roomData[kRoomId]);
  }

  @override
  Widget build(BuildContext context) {
    final backButton = FloatingButton(
      iconData: FontAwesomeIcons.chevronCircleLeft,
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final closeWebViewButton = FloatingButton(
      iconData: FontAwesomeIcons.timesCircle,
      onPressed: () {
        setState(() {
          showWebScreen = false;
        });
      },
    );

    final bottomTextArea = Container(
      height: 50,
      color: kImperialRed,
    );

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            showWebScreen
                ? WebViewScreen(documentRef: _documentRef)
                : SizedBox.shrink(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _documentRef.collection(kChatDataCollection).snapshots(),
                builder: (ctx, snapshot) {
                  return SizedBox.shrink();
                },
              ),
            ),
            bottomTextArea,
          ],
        ),
      ),
    );
  }
}
