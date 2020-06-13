import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';
import 'package:privateroom/widgets/not_found.dart';
import 'package:privateroom/widgets/room_item_widget.dart';

class ForegroundScreen extends StatefulWidget {
  final navBarOnPressed;

  ForegroundScreen({
    @required this.navBarOnPressed,
  });

  @override
  _ForegroundScreenState createState() => _ForegroundScreenState();
}

class _ForegroundScreenState extends State<ForegroundScreen> {
  final _firestore = Firestore.instance;

  bool showProgress = false;

  void showProgressIndicator(bool show) {
    setState(() {
      showProgress = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxHeight = SizedBox(
      height: 10.0,
    );

    final headingText = Text(
      'Private Chat',
      style: kHeadingTextStyle.copyWith(
        fontSize: 40,
      ),
      textAlign: TextAlign.center,
    );

    final titleText = Text(
      'Join a room to continue',
      style: kLightLabelTextStyle,
      textAlign: TextAlign.center,
    );

    final navButton = Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.bars,
          color: kWhite,
        ),
        onPressed: widget.navBarOnPressed,
      ),
    );

    final boxDecoration = BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    );

    final streamBuilder = StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(kRoomCollection).snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data.documents.isEmpty) return NotFoundWidget();

        List<Widget> widgets = [];
        List<DocumentSnapshot> ds = snapshot.data.documents;

        for (var room in ds) {
          widgets.add(RoomItemWidget(
            context: context,
            roomData: room,
            showProgressIndicator: showProgressIndicator,
          ));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
          itemCount: widgets.length,
          itemBuilder: (ctx, index) {
            return widgets[index];
          },
        );
      },
    );

    final circularProgressIndicator = Center(
      child: CircularProgressIndicator(),
    );

    final listOfRooms = Expanded(
      child: Container(
        decoration: boxDecoration,
        child: showProgress ? circularProgressIndicator : streamBuilder,
      ),
    );

    final mainCol = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        headingText,
        sizedBoxHeight,
        titleText,
        sizedBoxHeight,
        listOfRooms,
      ],
    );

    final foregroundScreen = Container(
      color: kImperialRed,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            mainCol,
            navButton,
          ],
        ),
      ),
    );

    return foregroundScreen;
  }
}
