import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/screens/messaging_screen/messaging_screen.dart';
import 'package:privateroom/services/encryption_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';
import 'package:privateroom/widgets/card_text_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RoomItemWidget extends StatelessWidget {
  RoomItemWidget({
    this.roomData,
    this.showProgressIndicator,
    this.context,
  });

  final context;
  final roomData;
  final showProgressIndicator;

  void showError(String error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kImperialRed,
        duration: const Duration(milliseconds: 1500),
        content: Text(
          error,
          style: kLabelTextStyle.copyWith(color: kWhite),
        ),
      ),
    );
  }

  void navigate(var password, var name) {
    final route = MaterialPageRoute(
      builder: (ctx) => MessagingScreen(
        roomData: roomData,
        password: password,
        name: name,
      ),
    );

    // move to new screen
    Navigator.push(context, route);
  }

  void enterRoom(
      String roomId, String password, String name, var context) async {
    Navigator.pop(context);

    showProgressIndicator(true);

    try {
      assert(password != null && password.isNotEmpty);

      final docSnapshot = await Firestore.instance
          .collection(kRoomCollection)
          .document(roomId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data;

        String actualRoomId = data[kRoomId];
        String encryptedRoomId = data[kEncryptedRoomId];
        String decryptedRoomId = '';

        try {
          decryptedRoomId = EncryptionService.decrypt(
              actualRoomId, password, encryptedRoomId);
        } catch (_) {
          showProgressIndicator(false);
          showError('Wrong Password');
          return;
        }

        if (decryptedRoomId == roomId) {
          showProgressIndicator(false);
          navigate(password, name);
        }
      } else {
        showProgressIndicator(false);
        showError('Room does not exists');
      }
    } catch (e) {
      if (e.toString().toLowerCase().contains('assertion')) {
        showProgressIndicator(false);
        showError('Password can\'t be empty');
      } else {
        showError('Invalid Room ID');
        showProgressIndicator(false);
      }
    }
  }

  void showLoginDialog(var context) {
    final passwordController = TextEditingController();
    final nameController = TextEditingController();

    final alertBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        width: 2.0,
        color: kImperialRed,
      ),
    );

    final alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      alertBorder: alertBorder,
      titleStyle: kHeadingTextStyle.copyWith(color: kImperialRed, fontSize: 30),
    );

    final alertContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 5),
        Text(
          'Room ID ${roomData[kRoomId]}',
          style: kLabelTextStyle,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10),
        CardTextField(
          iconData: FontAwesomeIcons.userTie,
          controller: nameController,
          labelText: 'Enter room as name?',
        ),
        CardTextField(
          iconData: FontAwesomeIcons.lock,
          controller: passwordController,
          labelText: 'Password',
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );

    final dialogButton = DialogButton(
      height: 50,
      width: 120,
      onPressed: () => enterRoom(
        roomData[kRoomId],
        passwordController.text.trim(),
        nameController.text.trim(),
        context,
      ),
      child: Text(
        "Verify",
        style: kGeneralTextStyle,
      ),
    );

    Alert(
      style: alertStyle,
      context: context,
      title: roomData[kRoomName],
      content: alertContent,
      buttons: [
        dialogButton,
      ],
      closeFunction: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: kImperialRed, width: 1),
    );

    final cardMargin = const EdgeInsets.only(
      bottom: 5,
      top: 10,
    );

    final contentPadding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 10,
    );

    final roomNameText = Text(
      roomData[kRoomName],
      style: kHeadingTextStyle.copyWith(fontSize: 30, color: kBlack),
    );

    final roomIdText = Text(
      'Room ID: ${roomData[kRoomId]}',
      style: kGeneralTextStyle.copyWith(fontSize: 15, color: kBlack),
    );

    final createdAtText = Text(
      'created at ${roomData[kRoomCreationDate]}',
      style: kLabelTextStyle.copyWith(fontSize: 15, color: kBlack),
    );

    return Card(
      color: Colors.white,
      elevation: 5,
      shape: shape,
      margin: cardMargin,
      child: InkWell(
        onTap: () => showLoginDialog(context),
        splashColor: kImperialRed.withAlpha(100),
        child: Padding(
          padding: contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              roomNameText,
              SizedBox(height: 20),
              roomIdText,
              createdAtText,
            ],
          ),
        ),
      ),
    );
  }
}
