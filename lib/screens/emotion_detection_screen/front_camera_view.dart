import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FrontCameraView extends StatefulWidget {
  final Function callback;
  final int cam;

  FrontCameraView({
    Key key,
    this.cam = 1,
    @required this.callback,
  }) : super(key: key);

  @override
  _FrontCameraViewState createState() => _FrontCameraViewState();
}

class _FrontCameraViewState extends State<FrontCameraView> {
  CameraController _cameraController;

  Timer timer;

  void _initTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      final path =
          (await getExternalStorageDirectory()).path + '/tmpImage.jpeg';

      try {
        await File(path).delete();
      } catch (e) {
        print(e);
      }

      // take picture
      await _cameraController.takePicture(path);

      widget.callback(File(path));
    });
  }

  void _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();

    _cameraController = CameraController(
      cameras[widget.cam],
      ResolutionPreset.high,
    );

    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initTimer();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null ||
        _cameraController.value == null ||
        !_cameraController.value.isInitialized) return Container();

    return AspectRatio(
      aspectRatio: 1,
      child: ClipRect(
        child: Transform.scale(
          scale: 1 / _cameraController.value.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          ),
        ),
      ),
    );
  }
}
