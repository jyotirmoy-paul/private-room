import 'package:flutter/material.dart';
import 'package:privateroom/utility/ui_constants.dart';

class NavItem extends StatelessWidget {
  final title;
  final iconData;
  final subTitle;
  final onTap;

  NavItem({
    @required this.title,
    @required this.iconData,
    @required this.subTitle,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: kTitleTextStyle,
      ),
      leading: Icon(
        iconData,
        color: kImperialRed,
        size: 30,
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle,
              style: kLightLabelTextStyle.copyWith(color: kBlack),
            )
          : null,
    );
  }
}
