import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:privateroom/screens/drawing_screen/drawing_screen.dart';
import 'package:privateroom/services/encoding_decoding_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';

class BottomSheetMenu extends StatelessWidget {
  BottomSheetMenu({
    @required this.toggleBrowser,
    @required this.chatDataCollectionReference,
    @required this.name,
    @required this.password,
  });

  final Function toggleBrowser;
  final chatDataCollectionReference;
  final String name;
  final String password;

  // todo: the image is not encrypted
  void uploadData(var imageBytes) async {
    var _ref = chatDataCollectionReference.document();
    var documentId = _ref.documentID;

    final StorageUploadTask uploadTask =
        FirebaseStorage.instance.ref().child(documentId).putData(imageBytes);

    var url =
        (await (await uploadTask.onComplete).ref.getDownloadURL()).toString();

    Map<String, dynamic> data = {
      kUserName: name,
      kTimestamp: DateFormat('HH:mm, dd MMM yyyy').format(DateTime.now()),
      kMessageBody: url,
      kIsDoodle: true,
    };

    String encryptedData = EncodingDecodingService.encodeAndEncrypt(
      data,
      documentId, // using doc id as IV
      password,
    );

    _ref.setData({
      'data': encryptedData,
      'id': documentId,
      'date': DateTime.now().toIso8601String().toString(),
    });
  }

  void openDoodleArea(var context) async {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (ctx) => DrawingScreen(),
    );

    var imageBytes = await Navigator.of(context).push(pageRoute);

    if (imageBytes == null) {
      return;
    }

    uploadData(imageBytes);
  }

  void setChatTheme() {}

  final sizedBoxWidth = SizedBox(width: 30.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            TileItem(
              iconData: FontAwesomeIcons.fileImage,
              title: 'Theme',
              onTap: setChatTheme,
            ),
            sizedBoxWidth,
            TileItem(
              iconData: FontAwesomeIcons.firefoxBrowser,
              title: 'Browser',
              onTap: () => toggleBrowser(),
            ),
            sizedBoxWidth,
            TileItem(
              iconData: FontAwesomeIcons.pencilRuler,
              title: 'Doodle',
              onTap: () => openDoodleArea(context),
            ),
          ],
        ),
      ),
    );
  }
}

class TileItem extends StatelessWidget {
  TileItem({
    this.iconData,
    this.title,
    this.onTap,
  });

  final iconData;
  final title;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: kImperialRed,
            size: 35.0,
          ),
          SizedBox(height: 10.0),
          Text(
            title,
            style: kLabelTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
