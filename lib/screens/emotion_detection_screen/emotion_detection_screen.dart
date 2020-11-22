import 'dart:io';

import 'package:flutter/material.dart';
import 'package:privateroom/model/prediction_class.dart';
import 'package:privateroom/screens/emotion_detection_screen/front_camera_view.dart';
import 'package:privateroom/services/emotion_prediction_service.dart';

class EmotionDetectionScreen extends StatefulWidget {
  @override
  _EmotionDetectionScreenState createState() => _EmotionDetectionScreenState();
}

class _EmotionDetectionScreenState extends State<EmotionDetectionScreen> {
  EmotionPredictionService emotionPredictionService =
      EmotionPredictionService();

  String prediction = '';

  Widget _buildCameraFeed({Widget child}) => ClipRRect(
        borderRadius: BorderRadius.circular(1000.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: child,
        ),
      );

  Widget _buildPredictionWidget({String text = 'You are Angry'}) => Container(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
          ),
        ),
      );

  // this function is called every X seconds
  // this function also invokes the EmotionPredictionService which gives out a prediction
  void imageCallback(File imageFile) async {
    List<PredictionClass> predClass =
        await emotionPredictionService.predict(imageFile);

    if (predClass.isEmpty) prediction = "Can't detect emotion";

    prediction =
        "You look ${predClass.first.label}. And I'm ${predClass.first.confidence * 100}% sure";

    setState(() {});
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Emotion Detection',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCameraFeed(
            child: FrontCameraView(
              callback: imageCallback,
            ),
          ),
          const SizedBox(height: 30.0),
          _buildPredictionWidget(text: prediction.isEmpty ? '' : prediction),
        ],
      ),
    );
  }
}
