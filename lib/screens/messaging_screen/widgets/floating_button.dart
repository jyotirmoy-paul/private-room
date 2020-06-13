import 'package:flutter/material.dart';
import 'package:privateroom/utility/ui_constants.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    @required this.iconData,
    @required this.onPressed,
  });

  final iconData;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: MaterialButton(
        elevation: 10.0,
        child: Icon(
          iconData,
          size: 30,
          color: kBlack,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
