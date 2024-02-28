import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';

import 'face_compare_service.dart';

class FaceDetectedService {
  late FaceDetector _faceDetector;

  void init() async {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  void stop() {
    _faceDetector.close();
  }

  Future<FaceDetected?> detectedFile({required String path}) async {
    var inputImage = await _getImageFile(path);
    if (inputImage != null) {
      var faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        print("Faces: ${faces.length}  file");
        return FaceDetected(
            imglib.decodeJpg((await _getImageFileFromAssets(path)).readAsBytesSync())!,
            faces.first);
      }
    }
    return null;
  }

  Future<FaceDetected?> detectedCamera({
    required CameraImage image,
    required CameraController controller,
  }) async {
    var inputImage = _inputImageFromCameraImage(image, controller);
    if (inputImage != null) {
      var faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        print("Faces: ${faces.length}  camera");
        return FaceDetected(_convertCameraImage(image), faces.first);
      }
    }
    return null;
  }

  void saveFaceFile(FaceDetected face, String name) async {
    imglib.Image image = cropFace(face.image, face.face);
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String filePath = '${extDir.path}/$name.jpg';
    print(filePath);
    File file = File(filePath);
    file.writeAsBytes(imglib.encodeJpg(image));
  }
}

class FaceDetected {
  final imglib.Image image;
  final Face face;

  FaceDetected(this.image, this.face);
}

imglib.Image _convertCameraImage(CameraImage image) {
  var img = convertToImage(image);
  var img1 = imglib.copyRotate(img!, 180);
  return img1;
}

Future<InputImage?> _getImageFile(String imagePath) async {
  File file = await _getImageFileFromAssets(imagePath);
  if (!file.existsSync()) return null;
  return InputImage.fromFile(file);
}

Future<File> _getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file
      .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

InputImage? _inputImageFromCameraImage(CameraImage image, CameraController controller) {
  final sensorOrientation = controller.description.sensorOrientation;
  InputImageRotation? rotation;
  if (GetPlatform.isIOS) {
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  } else if (GetPlatform.isAndroid) {
    var rotationCompensation = _orientations[controller.value.deviceOrientation];
    if (rotationCompensation == null) return null;
    if (controller.description.lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
    }
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
  }
  if (rotation == null) return null;

  final format = InputImageFormatValue.fromRawValue(image.format.raw);
  if (format == null ||
      (GetPlatform.isAndroid && format != InputImageFormat.nv21) ||
      (GetPlatform.isIOS && format != InputImageFormat.bgra8888)) return null;
  if (image.planes.length != 1) return null;
  final plane = image.planes.first;
  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation, // used only in Android
      format: format, // used only in iOS
      bytesPerRow: plane.bytesPerRow, // used only in iOS
    ),
  );
}

imglib.Image? convertToImage(CameraImage image) {
  try {
    if (image.format.group == ImageFormatGroup.nv21) {
      return _convertNV21(image);
    } else if (image.format.group == ImageFormatGroup.bgra8888) {
      return _convertBGRA8888(image);
    }
    throw Exception('Image format not supported');
  } catch (e) {
    print("ERROR:" + e.toString());
  }
  return null;
}

imglib.Image _convertBGRA8888(CameraImage image) {
  return imglib.Image.fromBytes(
    image.width,
    image.height,
    image.planes[0].bytes,
    format: imglib.Format.bgra,
  );
}

imglib.Image _convertNV21(CameraImage image) {
  final width = image.width.toInt();
  final height = image.height.toInt();
  Uint8List yuv420sp = image.planes[0].bytes;

  // Initial conversion from NV21 to RGB
  final outImg = imglib.Image(height, width); // Note the swapped dimensions
  final int frameSize = width * height;

  for (int j = 0, yp = 0; j < height; j++) {
    int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
    for (int i = 0; i < width; i++, yp++) {
      int y = (0xff & yuv420sp[yp]) - 16;
      if (y < 0) y = 0;
      if ((i & 1) == 0) {
        v = (0xff & yuv420sp[uvp++]) - 128;
        u = (0xff & yuv420sp[uvp++]) - 128;
      }
      int y1192 = 1192 * y;
      int r = (y1192 + 1634 * v);
      int g = (y1192 - 833 * v - 400 * u);
      int b = (y1192 + 2066 * u);

      if (r < 0) {
        r = 0;
      } else if (r > 262143) r = 262143;
      if (g < 0) {
        g = 0;
      } else if (g > 262143) g = 262143;
      if (b < 0) {
        b = 0;
      } else if (b > 262143) b = 262143;

      outImg.setPixelRgba(j, width - i - 1, ((r << 6) & 0xff0000) >> 16, ((g >> 2) & 0xff00) >> 8,
          (b >> 10) & 0xff);
    }
  }
  return outImg;
  // Rotate the image by 90 degrees (or 270 degrees if needed)
  // return imglib.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
}
