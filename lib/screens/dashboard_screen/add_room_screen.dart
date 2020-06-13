import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:privateroom/services/encryption_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';
import 'package:privateroom/widgets/card_text_field.dart';

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _firestore = Firestore.instance;

  final _roomNameController = TextEditingController();
  final _roomPasswordController = TextEditingController();

  bool showProgress = false;

  void createNewRoom() async {
    setState(() {
      showProgress = true;
    });

    String inputRoomName = _roomNameController.text.trim();
    String inputRoomPassword = _roomPasswordController.text.trim();

    _roomPasswordController.clear();
    _roomNameController.clear();

    assert(inputRoomName != null && inputRoomName.isNotEmpty);
    assert(inputRoomPassword != null && inputRoomPassword.isNotEmpty);

    var ref = _firestore.collection(kRoomCollection).document();

    String roomId = ref.documentID;
    String roomName = inputRoomName;
    String roomCreationDate =
        DateFormat('HH:mm, dd MMMM, yyyy').format(DateTime.now());
    String encryptedRoomId =
        EncryptionService.encrypt(roomId, inputRoomPassword, roomId);

    await ref.setData({
      kRoomId: roomId,
      kEncryptedRoomId: encryptedRoomId,
      kRoomName: roomName,
      kRoomCreationDate: roomCreationDate,
    });

    setState(() {
      showProgress = false;
    });
  }

  @override
  void dispose() {
    _roomPasswordController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var containerPadding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    );

    var sizedBox20 = SizedBox(
      height: 20,
    );

    var headingText = Text(
      'Add a new Room',
      style: kHeadingTextStyle,
      textAlign: TextAlign.center,
    );

    var labelText = Text(
      'To add a new room, please enter a password. After which, you will be provided with an auto-generated Room ID. Share the ID with other\'s to allow them to join your room.',
      style: kLightLabelTextStyle,
      textAlign: TextAlign.center,
    );

    var textFieldNewRoomPassword = CardTextField(
      controller: _roomPasswordController,
      obscureText: true,
      labelText: 'New Room Password',
      keyboardType: TextInputType.visiblePassword,
      iconData: FontAwesomeIcons.lock,
    );

    var textFieldRoomName = CardTextField(
      controller: _roomNameController,
      labelText: 'Room Name',
      iconData: FontAwesomeIcons.napster,
    );

    var createRoomButton = RaisedButton(
      child: Text(
        'Create Room',
        style: kGeneralTextStyle,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      color: kImperialRed,
      splashColor: kWhite,
      onPressed: createNewRoom,
    );

    return Scaffold(
      backgroundColor: kSteelBlue,
      body: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: containerPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                headingText,
                sizedBox20,
                labelText,
                sizedBox20,
                textFieldRoomName,
                sizedBox20,
                textFieldNewRoomPassword,
                sizedBox20,
                sizedBox20,
                createRoomButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
