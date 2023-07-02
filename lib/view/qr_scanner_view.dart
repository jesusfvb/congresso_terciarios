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

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    void _onQRViewCreated(QRViewController controller) {
      controller.resumeCamera();
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        controller.stopCamera();
        var idUser =
            scanData.code?.substring(0, scanData.code!.length - 1).replaceAll("http://", "");
        var user = userState.getUserById(idUser!);
        if (user != null) {
          eventState.saveParticipation(user.id);
          showModalBottomSheet(
              context: context,
              builder: (context) => ButtonSheetQrDataComponent(
                    user: user,
                  )).whenComplete(() {
            controller.stopCamera();
            Get.back();
          });
        } else {
          showModalBottomSheet(
              context: context,
              builder: (context) => ButtonSheetQrErrorComponent()).whenComplete(() {
            controller.stopCamera();
            Get.back();
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
}
