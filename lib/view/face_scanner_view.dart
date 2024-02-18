import 'package:camera/camera.dart';
import 'package:congresso_terciarios/component/botton_navigation_bar_camera_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceScannerView extends StatefulWidget {
  late final List<CameraDescription> _cameras;

  FaceScannerView({super.key, required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }

  @override
  State<FaceScannerView> createState() => _FaceScannerViewState();
}

class _FaceScannerViewState extends State<FaceScannerView> {
  CameraController? _controller;
  int _cameraIndex = -1;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _liveFeedBody(),
        bottomNavigationBar: BottomNavigationBarCameraComponent(
          onBackPressed: () {
            Get.back();
          },
        ));
  }

  Widget _liveFeedBody() {
    if (widget._cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: CameraPreview(
              _controller!,
            ),
          ),
        ],
      ),
    );
  }

  void _initialize() async {
    if (widget._cameras.isEmpty) {
      widget._cameras = await availableCameras();
    }
    for (var i = 0; i < widget._cameras.length; i++) {
      if (widget._cameras[i].lensDirection == CameraLensDirection.back) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  void _startLiveFeed() async {
    final camera = widget._cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: GetPlatform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      // _controller?.startImageStream(_processCameraImage).then((value) {
      //   if (widget.onCameraFeedReady != null) {
      //     widget.onCameraFeedReady!();
      //   }
      //   if (widget.onCameraLensDirectionChanged != null) {
      //     widget.onCameraLensDirectionChanged!(camera.lensDirection);
      //   }
      // });
      setState(() {});
    });
  }

  void _stopLiveFeed() {
    // _controller?.stopImageStream();
    _controller?.dispose();
    _controller = null;
  }
}
