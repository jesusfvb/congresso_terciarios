import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:congresso_terciarios/generated/assets.dart';
import 'package:congresso_terciarios/service/face_detected_service.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceCompareService {
  late Interpreter _interpreter;

  Future<void> _init() async {
    Delegate? delegate;
    try {
      if (GetPlatform.isAndroid) {
        delegate = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
          isPrecisionLossAllowed: false,
          inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
          inferencePriority1: TfLiteGpuInferencePriority.minLatency,
          inferencePriority2: TfLiteGpuInferencePriority.auto,
          inferencePriority3: TfLiteGpuInferencePriority.auto,
        ));
      } else if (GetPlatform.isIOS) {
        delegate = GpuDelegate(
          options:
              GpuDelegateOptions(allowPrecisionLoss: true, waitType: TFLGpuDelegateWaitType.active),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate!);

      _interpreter =
          await Interpreter.fromAsset(Assets.iaMobileFaceNet.replaceFirst("assets/", ""), options: interpreterOptions);
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  Future<void> compare({required FaceDetected face1, required FaceDetected face2}) async {
    var output1 = await _process(faceDetected: face1);
    var output2 = await _process(faceDetected: face2);

    int minDist = 999;
    double threshold = 1.0;
    num currDist = _euclideanDistance(output1, output2);

    print("*****************************************************");
    print("Euclidean distance");
    print(currDist );
    print("*****************************************************");

    if (currDist <= threshold && currDist < minDist) {
      print("*****************************************************");
      print("true");
      print("*****************************************************");
    } else {
      print("*****************************************************");
      print("false");
      print("*****************************************************");
    }
  }

  Future<List> _process({required FaceDetected faceDetected}) async {
    List input = _preProcess(faceDetected.image, faceDetected.face);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    await _init();

    _interpreter.run(input, output);
    output = output.reshape([192]);
    return output;
  }

  double _euclideanDistance(List e1, List e2) {
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  List _preProcess(imglib.Image image, Face faceDetected) {
    imglib.Image croppedImage = cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = _imageToByteListFloat32(img);
    return imageAsList;
  }

  Float32List _imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}

imglib.Image cropFace(imglib.Image image, Face faceDetected) {
  // imglib.Image convertedImage = _convertCameraImage(image);
  imglib.Image convertedImage = image;
  double x = faceDetected.boundingBox.left - 10.0;
  double y = faceDetected.boundingBox.top - 10.0;
  double w = faceDetected.boundingBox.width + 10.0;
  double h = faceDetected.boundingBox.height + 10.0;
  return imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(), h.round());
}
