import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/screens/dashboard_screen/add_room_screen.dart';
import 'package:privateroom/screens/dashboard_screen/nav_item.dart';
import 'package:privateroom/utility/ui_constants.dart';

class NavBarScreen extends StatelessWidget {
  final onPressed;

  NavBarScreen({
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final shrinkSizedBox = Expanded(
      child: SizedBox.shrink(),
    );

    final headingText = Text(
      'Menu',
      style: kHeadingTextStyle.copyWith(fontSize: 30, color: kBlack),
      textAlign: TextAlign.center,
    );

    final sizedBox10 = SizedBox(height: 10);
    final sizedBox30 = SizedBox(height: 30);

    final navItemClose = NavItem(
      onTap: onPressed,
      title: 'Close Navigation Bar',
      iconData: FontAwesomeIcons.times,
      subTitle: '',
    );

    final navItemAddRoom = NavItem(
      onTap: () {
        onPressed();
        final route = MaterialPageRoute(builder: (ctx) => AddRoomScreen());
        Navigator.push(context, route);
      },
      title: 'New Room',
      iconData: FontAwesomeIcons.users,
      subTitle: 'Add a new room. And, invite your friends.',
    );

    final navItemReportBug = NavItem(
      onTap: () {
        // todo: add github repo link
      },
      title: 'Report a bug',
      iconData: FontAwesomeIcons.bug,
      subTitle: 'File an issue on the Github Repo',
    );

    return Row(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              sizedBox10,
              headingText,
              sizedBox30,
              navItemClose,
              navItemAddRoom,
              sizedBox30,
              navItemReportBug,
            ],
          ),
        ),
        shrinkSizedBox,
      ],
    );
  }
}
