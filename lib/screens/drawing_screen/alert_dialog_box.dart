import 'package:flutter/material.dart';
import 'package:privateroom/utility/ui_constants.dart';

class AlertDialogBox extends StatefulWidget {
  AlertDialogBox({
    @required this.strokeWidth,
  });

  final strokeWidth;

  @override
  _AlertDialogBoxState createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  double strokeWidth = 0.0;

  @override
  void initState() {
    super.initState();
    strokeWidth = widget.strokeWidth;
  }

  @override
  Widget build(BuildContext context) {
    var titleText = Text(
      'Select Stroke size',
      style: kLabelTextStyle,
      textAlign: TextAlign.center,
    );

    var flatButton = FlatButton(
      child: Text('Got it', style: kLabelTextStyle),
      onPressed: () {
        Navigator.of(context).pop(strokeWidth);
      },
    );

    return AlertDialog(
      title: titleText,
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              strokeWidth.toStringAsFixed(2),
              style: kLabelTextStyle,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  inactiveTrackColor: Color(0xff8d8e98),
                  activeTrackColor: kImperialRed,
                  thumbColor: kImperialRed,
                  overlayColor: kImperialRed.withOpacity(0.30),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 15.0,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 30.0,
                  )),
              child: Slider(
                value: strokeWidth,
                min: 0.5,
                max: 20.0,
                onChanged: (double newValue) {
                  setState(() {
                    strokeWidth = newValue;
                  });
                },
              ),
            ),
            flatButton,
          ],
        ),
      ),
    );
  }
}
