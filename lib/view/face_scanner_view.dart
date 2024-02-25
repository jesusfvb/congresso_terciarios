import 'dart:io';

import 'package:camera/camera.dart';
import 'package:congresso_terciarios/component/botton_navigation_bar_camera_component.dart';
import 'package:congresso_terciarios/generated/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';

class FaceScannerView extends StatefulWidget {
  late final List<CameraDescription> _cameras;

  FaceScannerView({super.key, required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }

  @override
  State<FaceScannerView> createState() => _FaceScannerViewState();
}

class _FaceScannerViewState extends State<FaceScannerView> {
  //Camera
  late CameraController _controller;

  //Face
  late FaceDetector _faceDetector;
  final List<Face> _faces = [];
  bool _canProcess = true;
  bool _isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: Get.width,
          height: Get.height,
          // child: CameraPreview(_controller),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBarCameraComponent(
        onBackPressed: () {
          _detectFacesImage(Assets.imgDescarga);
          // _stop();
          // Get.back();
        },
      ),
    );
  }

  @override
  void initState() {
    // _initCamera();
    _initFaceDetector();
    super.initState();
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  void _stop() {
    _canProcess = false;
    _faceDetector.close();
    // _controller.dispose();
  }

  //Camera
  void _initCamera() async {
    _controller = CameraController(
      widget._cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: GetPlatform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await _controller.initialize().then((_) {
      _controller.startImageStream((image) {
        _detectFacesCameraImage(image);
      });
    });
    if (!mounted) return;
    setState(() {});
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final sensorOrientation = _controller.description.sensorOrientation;
    InputImageRotation? rotation;
    if (GetPlatform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (GetPlatform.isAndroid) {
      var rotationCompensation = _orientations[_controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (_controller.description.lensDirection == CameraLensDirection.front) {
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

//Face
  void _initFaceDetector() async {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  void _detectFacesCameraImage(CameraImage image) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    var inputImage = _inputImageFromCameraImage(image);
    if (inputImage != null) {
      var faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        print("Faces: ${faces.length}");
        _isBusy = false;
        setState(() {
          _faces.clear();
          _faces.addAll(faces);
        });
      }
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _detectFacesImage(String imagePath) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    var inputImage = await _getImageFile(imagePath);
    if (inputImage != null) {
      var faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        print("Faces: ${faces.length}");
        _isBusy = false;
        setState(() {
          _faces.clear();
          _faces.addAll(faces);
        });
      }
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  //Image File
  Future<InputImage?> _getImageFile(String imagePath) async {
    File file = await getImageFileFromAssets(imagePath);
    if (!file.existsSync()) return null;
    return InputImage.fromFile(file);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
