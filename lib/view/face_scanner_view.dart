import 'dart:io';

import 'package:camera/camera.dart';
import 'package:congresso_terciarios/component/botton_navigation_bar_camera_component.dart';
import 'package:congresso_terciarios/service/face_detected_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';

import '../generated/assets.dart';
import '../service/face_compare_service.dart';

class FaceScannerView extends StatefulWidget {
  late final List<CameraDescription> _cameras;

  FaceScannerView({super.key, required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }

  @override
  State<FaceScannerView> createState() => _FaceScannerViewState();
}

class _FaceScannerViewState extends State<FaceScannerView> {
  late CameraController _controller;

  final FaceCompareService _faceCompareService = FaceCompareService();
  final FaceDetectedService _detectedService = FaceDetectedService();

  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: CameraPreview(_controller),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBarCameraComponent(
        onBackPressed: () async {
          // var face =  await _detectedService.detectedFile(path: Assets.imgDescarga);
          // var face2 =  await _detectedService.detectedFile(path: Assets.imgImg2);
          // _faceCompareService.compare(face1: face!, face2: face);
          _stop();
          Get.back();
        },
      ),
    );
  }

  @override
  void initState() {
    _initCamera();
    _detectedService.init();
    super.initState();
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  void _initCamera() async {
    _controller = CameraController(
      widget._cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: GetPlatform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await _controller.initialize().then((_) {
      _controller.startImageStream(_captureImage);
    });
    if (!mounted) return;
    setState(() {});
  }

  void _stop() {
    _controller.dispose();
    _detectedService.stop();
  }

  void _captureImage(CameraImage image) async {
    if (!mounted) return;
    if (isBusy) return;
    isBusy = true;
    var face = await _detectedService.detectedCamera(image: image, controller: _controller);
    var face2 = await _detectedService.detectedFile(path: Assets.imgDescarga);

    if (face != null && face2 != null) {
      await _faceCompareService.compare(face1: face, face2: face2);
    }
    isBusy = false;
  }
}

imglib.Image _cropFace(imglib.Image image, Face faceDetected) {
  // imglib.Image convertedImage = _convertCameraImage(image);
  imglib.Image convertedImage = image;
  double x = faceDetected.boundingBox.left - 10.0;
  double y = faceDetected.boundingBox.top - 10.0;
  double w = faceDetected.boundingBox.width + 10.0;
  double h = faceDetected.boundingBox.height + 10.0;
  return imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(), h.round());
}
