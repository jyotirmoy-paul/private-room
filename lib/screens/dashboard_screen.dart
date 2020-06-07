import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/screens/messaging_screen/messaging_screen.dart';
import 'package:privateroom/services/encryption_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _firestore = Firestore.instance;
  final _roomIdController = TextEditingController();
  final _passwordController = TextEditingController();

  void showError(String error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kImperialRed,
        content: Text(
          error,
          style: kLabelTextStyle.copyWith(color: kWhite),
        ),
      ),
    );
  }

  void navigate() {
    final route = MaterialPageRoute(
      builder: (ctx) => MessagingScreen(),
    );
    Navigator.pushReplacement(context, route);
  }

  void enterRoom(String roomId, String password) async {
    try {
      assert(roomId != null && roomId.isNotEmpty);
      assert(password != null && password.isNotEmpty);

      final docSnapshot =
          await _firestore.collection(kRoomCollection).document(roomId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data;

        String actualRoomId = data[kRoomId];
        String encryptedRoomId = data[kEncryptedRoomId];
        String decryptedRoomId = '';

        try {
          decryptedRoomId = EncryptionService.decrypt(
              actualRoomId, password, encryptedRoomId);
        } catch (_) {
          showError('Wrong Password');
          return;
        }

        if (decryptedRoomId == roomId) {
          navigate();
          return;
        }
      } else {
        showError('Room does not exists');
      }
    } catch (_) {
      showError('Invalid Room ID');
    }
  }

  @override
  void dispose() {
    _roomIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizedBoxHeight = SizedBox(height: 50.0);

    var headingText = Text(
      'Join a Room',
      style: kHeadingTextStyle,
      textAlign: TextAlign.center,
    );

    var enterRoomButton = RaisedButton(
      child: Text(
        'Enter Room',
        style: kGeneralTextStyle,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      color: kImperialRed,
      splashColor: kWhite,
      onPressed: () => enterRoom(
        _roomIdController.text.trim(),
        _passwordController.text.trim(),
      ),
    );

    var textFieldRoomId = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          style: kLabelTextStyle,
          controller: _roomIdController,
          decoration: InputDecoration(
            icon: Icon(FontAwesomeIcons.userTie, color: kSteelBlue),
            labelText: 'Room ID',
            labelStyle: kLightLabelTextStyle,
            border: InputBorder.none,
          ),
        ),
      ),
    );

    var textFieldRoomPassword = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          controller: _passwordController,
          style: kLabelTextStyle,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            icon: Icon(FontAwesomeIcons.lock, color: kSteelBlue),
            labelText: 'Password',
            labelStyle: kLightLabelTextStyle,
            border: InputBorder.none,
          ),
        ),
      ),
    );

    var boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff5E5C5C),
          Color(0xff9DC5C3),
        ],
      ),
    );

    return Container(
      decoration: boxDecoration,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          headingText,
          sizedBoxHeight,
          textFieldRoomId,
          textFieldRoomPassword,
          sizedBoxHeight,
          enterRoomButton,
        ],
      ),
    );
  }
}
