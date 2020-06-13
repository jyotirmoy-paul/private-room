import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/utility/ui_constants.dart';

class NotFoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'No Rooms Found',
          style: kHeadingTextStyle.copyWith(fontSize: 40, color: kBlack),
        ),
        Text(
          'Try creating a new room',
          style: kLabelTextStyle.copyWith(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Icon(
          FontAwesomeIcons.archive,
          size: 100,
          color: kSteelBlue,
        ),
      ],
    );
  }
}
