import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:privateroom/model/prediction_class.dart';
import 'package:privateroom/screens/emotion_detection_screen/front_camera_view.dart';
import 'package:privateroom/services/emotion_prediction_service.dart';
import 'package:privateroom/utility/ui_constants.dart';

class EmotionDetectionScreen extends StatefulWidget {
  @override
  _EmotionDetectionScreenState createState() => _EmotionDetectionScreenState();
}

class _EmotionDetectionScreenState extends State<EmotionDetectionScreen> {
  EmotionPredictionService emotionPredictionService =
      EmotionPredictionService();

  PredictionClass _predictionClass;

  // default camera set to front camera
  bool cam = true; // true means front camera

  Widget _buildCameraFeed({Widget child}) => Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kSteelBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20.0,
              spreadRadius: 5.0,
            )
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000.0),
          child: child,
        ),
      );

  Widget _buildPredictionWidget() => Container(
        child: Column(
          children: [
            Text(
              _predictionClass == null ? '' : 'You look'.toUpperCase(),
              textAlign: TextAlign.center,
              style: kLabelTextStyle,
            ),

            Text(
              _predictionClass == null
                  ? 'No Emotion Detected'
                  : _predictionClass.label.toUpperCase(),
              textAlign: TextAlign.center,
              style: kTitleTextStyle.copyWith(
                fontSize: 30.0,
                color: kImperialRed,
              ),
            ),

            // show confidence level
            Text(
              _predictionClass == null
                  ? ''
                  : 'Confidence: ${(_predictionClass.confidence * 100).toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: kLabelTextStyle,
            ),
          ],
        ),
      );

  Widget _buildAppBar() => Container(
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kImperialRed,
          boxShadow: [BoxShadow(blurRadius: 20.0)],
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
              MediaQuery.of(context).size.width,
              100.0,
            ),
          ),
        ),
        child: Center(
          child: Text(
            'Emotion Detection',
            style: kHeadingTextStyle.copyWith(
              fontSize: 35.0,
            ),
          ),
        ),
      );

  Widget _buildSwitchCameraWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Rear Camera',
            style: kLabelTextStyle,
          ),
          const SizedBox(width: 10.0),
          CupertinoSwitch(
            activeColor: kImperialRed,
            trackColor: kSteelBlue,
            value: cam,
            onChanged: (bool value) => setState(() => cam = value),
          ),
          const SizedBox(width: 10.0),
          Text(
            'Front Camera',
            style: kLabelTextStyle,
          ),
        ],
      );

  // this function is called every X seconds
  // this function also invokes the EmotionPredictionService which gives out a prediction
  void imageCallback(File imageFile) async {
    List<PredictionClass> predClass =
        await emotionPredictionService.predict(imageFile);

    if (predClass.isEmpty)
      _predictionClass = null;
    else {
      _predictionClass = predClass.first;
      _predictionClass.label += '\n';

      switch (_predictionClass.label.trim().toLowerCase()) {
        case 'happy':
          _predictionClass.label += kEmojiHappy;
          break;
        case 'sad':
          _predictionClass.label += kEmojiSad;
          break;
        case 'angry':
          _predictionClass.label += kEmojiAngry;
          break;
        case 'surprised':
          _predictionClass.label += kEmojiSurprised;
          break;
        case 'fear':
          _predictionClass.label += kEmojiFear;
          break;
      }
    }

    setState(() => {});
  }

  @override
  void initState() {
    super.initState();
    emotionPredictionService.init();
  }

  @override
  void dispose() {
    emotionPredictionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // app bar g
          _buildAppBar(),
          Spacer(),

          _buildSwitchCameraWidget(),
          Spacer(),

          // round camera feed
          _buildCameraFeed(
            child: cam
                ? FrontCameraView(
                    key: ValueKey(1),
                    cam: 1,
                    callback: imageCallback,
                  )
                : FrontCameraView(
                    key: ValueKey(0),
                    cam: 0,
                    callback: imageCallback,
                  ),
          ),
          Spacer(),
          _buildPredictionWidget(),
          Spacer(),
        ],
      ),
    );
  }
}
