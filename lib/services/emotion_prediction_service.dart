import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privateroom/model/prediction_class.dart';
import 'package:tflite/tflite.dart';

class EmotionPredictionService {
  Future<void> init() async {
    String res = await Tflite.loadModel(
      model: "assets/model/face_model.tflite",
      labels: "assets/model/labels",
      numThreads: 2,
      isAsset: true,
      useGpuDelegate: true,
    );

    print(res);
  }

  void dispose() => Tflite.close();

  /*
  {'angry_faces': 0,
 'fear_faces': 1,
 'happy_faces': 2,
 'sad_faces': 3,
 'surprised_faces': 4}
   */

  static Uint8List imageToByteListFloat32(Image image, int inputSize) {
    var convertedBytes = Float32List(inputSize * inputSize);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] =
            (getRed(pixel) + getGreen(pixel) + getBlue(pixel)) / 3 / 255.0;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  static double convertPixel(int color) {
    return (255 -
            (((color >> 16) & 0xFF) * 0.299 +
                ((color >> 8) & 0xFF) * 0.587 +
                (color & 0xFF) * 0.114)) /
        255.0;
  }

  static Future<Image> preProcessImage(File imageFile) async {
    Image img = decodeImage(imageFile.readAsBytesSync());

    // center crop the image
    Image croppedImage = copyResizeCropSquare(img, img.width);

    // resize image to 48x48
    Image resizedImage = copyResize(croppedImage, width: 48, height: 48);

    return resizedImage;
  }

  Future<List<PredictionClass>> predict(File image) async {
    // reduce image size to 48x48
    Image img = await preProcessImage(image);

    List recognitions = await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(img, 48),
    );

    log(recognitions.toString());

    return recognitions
        .map<PredictionClass>((data) => PredictionClass.fromJson(data))
        .toList();
  }
}
