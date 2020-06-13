import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privateroom/screens/drawing_screen/consts.dart';
import 'package:privateroom/screens/drawing_screen/drawing_points.dart';
import 'package:privateroom/screens/drawing_screen/painter.dart';
import 'package:privateroom/utility/ui_constants.dart';
import 'package:privateroom/screens/drawing_screen/alert_dialog_box.dart';

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  // sketching property

  PictureRecorder _recorder;
  Canvas _canvas;

  Color backgroundColor = kWhite;
  Color penColor = kImperialRed;
  double strokeWidth = 3.0;
  Size availableSize;

  final dpr = window.devicePixelRatio;
  final List<DrawingPoints> _points = [];

  void onPanStart(DragStartDetails details) {
    setState(() {
      RenderBox renderBox = context.findRenderObject();
      Offset localPos = renderBox.globalToLocal(details.globalPosition);
      _points.add(
        DrawingPoints(
          offset: localPos,
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..color = penColor
            ..isAntiAlias = true
            ..strokeCap = StrokeCap.round
            ..strokeWidth = strokeWidth,
        ),
      );
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      RenderBox renderBox = context.findRenderObject();
      Offset localPos = renderBox.globalToLocal(details.globalPosition);
      _points.add(
        DrawingPoints(
          offset: localPos,
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..color = penColor
            ..isAntiAlias = true
            ..strokeCap = StrokeCap.round
            ..strokeWidth = strokeWidth,
        ),
      );
    });
  }

  void onPanEnd(DragEndDetails details) {
    setState(() {
      _points.add(null);
    });
  }

  void selectStrokeSize() async {
    strokeWidth = await showDialog<double>(
          context: context,
          builder: (ctx) => AlertDialogBox(
            strokeWidth: strokeWidth,
          ),
        ) ??
        strokeWidth;
    setState(() {});
  }

  void chooseColor(colorFor c) {
    var titleText = const Text(
      'Pick a color',
      style: kLabelTextStyle,
      textAlign: TextAlign.center,
    );

    showDialog(
      context: context,
      child: AlertDialog(
        title: titleText,
        content: SingleChildScrollView(
          child: ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: c == colorFor.pen ? penColor : backgroundColor,
            onColorChanged: (Color color) {
              c == colorFor.pen ? penColor = color : backgroundColor = color;
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() {});
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void generateImage() async {
    final picture = _recorder.endRecording();

    final imageWidth = (availableSize.width * dpr).toInt();
    final imageHeight = (availableSize.height * dpr).toInt();

    final img = await picture.toImage(imageWidth, imageHeight);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);
    Uint8List imageBytes = Uint8List.view(pngBytes.buffer);

    Navigator.of(context).pop(imageBytes);
  }

  void initializeRecording() {
    _recorder = PictureRecorder();
    _canvas = Canvas(_recorder);
    _canvas.scale(dpr, dpr);
  }

  void quit() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    initializeRecording();
  }

  @override
  Widget build(BuildContext context) {
    var quitItem = SpeedDialChild(
      child: Icon(FontAwesomeIcons.reply),
      backgroundColor: Colors.black,
      label: 'Exit',
      labelStyle: kLabelTextStyle,
      onTap: quit,
    );
    var sendItem = SpeedDialChild(
      child: Icon(FontAwesomeIcons.share),
      backgroundColor: Colors.deepOrange,
      label: 'Send',
      labelStyle: kLabelTextStyle,
      onTap: generateImage,
    );
    var clearItem = SpeedDialChild(
      child: Icon(FontAwesomeIcons.times),
      backgroundColor: Colors.blue,
      label: 'Clear',
      labelStyle: kLabelTextStyle,
      onTap: () => _points.clear(),
    );
    var penColorItem = SpeedDialChild(
      child: Icon(FontAwesomeIcons.palette),
      backgroundColor: Colors.green,
      label: 'Pen Color',
      labelStyle: kLabelTextStyle,
      onTap: () => chooseColor(colorFor.pen),
    );
    var strokeSizeItem = SpeedDialChild(
      child: Icon(FontAwesomeIcons.dotCircle),
      backgroundColor: Colors.orange,
      label: 'Stroke Size',
      labelStyle: kLabelTextStyle,
      onTap: selectStrokeSize,
    );
    var backgroundColorItem = SpeedDialChild(
      child: Icon(FontAwesomeIcons.paintRoller),
      backgroundColor: Colors.purple,
      label: 'Background Color',
      labelStyle: kLabelTextStyle,
      onTap: () => chooseColor(colorFor.background),
    );

    var floatingActionButton = SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: kImperialRed,
      foregroundColor: Colors.white,
      elevation: 10.0,
      shape: CircleBorder(),
      children: [
        quitItem,
        sendItem,
        clearItem,
        penColorItem,
        strokeSizeItem,
        backgroundColorItem,
      ],
    );

    availableSize = MediaQuery.of(context).size;

    _canvas.drawColor(backgroundColor, BlendMode.srcOver);
    var _drawing = Drawing(points: _points)..paint(_canvas, availableSize);

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: CustomPaint(
            painter: _drawing,
            size: availableSize,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
