import 'package:audioplayers/audioplayers.dart';
import 'package:congresso_terciarios/component/button_sheet_qr_component.dart';
import 'package:congresso_terciarios/state/event_state.dart';
import 'package:congresso_terciarios/state/user_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerView extends StatelessWidget {
  QrScannerView({super.key});

  final EventState eventState = Get.find();
  final UserState userState = Get.find();

  final player = AudioPlayer();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    void _onQRViewCreated(QRViewController controller) {
      controller.resumeCamera();
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) async {
        controller.stopCamera();
        var user = userState.getUserById(_getIdUser(scanData.code));
        print(user);
        if (user != null) {
          eventState.saveParticipation(user.id);
          await player.play(AssetSource("sound/correct.mp3"));
          await showModalBottomSheet(
              context: context,
              builder: (context) => ButtonSheetQrDataComponent(
                    user: user,
                  )).timeout(2.seconds, onTimeout: () {
            Get.back();
          }).whenComplete(() {
            controller.resumeCamera();
          });
        } else {
          await player.play(AssetSource("sound/error.mp3"));
          await showModalBottomSheet(
              context: context,
              builder: (context) => ButtonSheetQrErrorComponent()).whenComplete(() {
            controller.resumeCamera();
          });
        }
        controller.stopCamera();
      });
    }

    return Scaffold(
        body: QRView(
          key: qrKey,
          formatsAllowed: const [BarcodeFormat.qrcode],
          onQRViewCreated: _onQRViewCreated,
          overlayMargin: const EdgeInsets.all(0),
          overlay: QrScannerOverlayShape(
              borderColor: Colors.lightBlue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 200),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    controller?.stopCamera();
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.lightBlue,
                  )),
              IconButton(
                  color: Colors.lightBlue,
                  onPressed: () {
                    controller!.toggleFlash();
                  },
                  icon: const Icon(Icons.flash_on)),
            ],
          ),
        ));
  }

  String _getIdUser(String? qrData) {
    if (qrData == null) return "";
    if (qrData.startsWith("http://")) {
      qrData = qrData.replaceAll("http://", "");
    }
    if (qrData.startsWith("https://")) {
      qrData = qrData.replaceAll("https://", "");
    }
    if (qrData.endsWith("/")) {
      qrData = qrData.replaceAll("/", "");
    }
    return qrData.removeAllWhitespace;
  }
}
