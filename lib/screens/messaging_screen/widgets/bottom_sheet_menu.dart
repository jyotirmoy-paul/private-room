import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/utility/ui_constants.dart';

class BottomSheetMenu extends StatelessWidget {
  BottomSheetMenu({
    @required this.toggleBrowser,
  });

  final Function toggleBrowser;

  void openDoodleArea() {}
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
              onTap: openDoodleArea,
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
        onTap();
        Navigator.pop(context);
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
