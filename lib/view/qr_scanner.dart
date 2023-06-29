import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatelessWidget {
  QRScanner({super.key});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print("************************************************************");
      print(scanData.code?.substring(0, scanData.code!.length - 1).replaceAll("http://", ""));
      print("************************************************************");
      controller.stopCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
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
}
