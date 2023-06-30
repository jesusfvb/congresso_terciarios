import 'package:congresso_terciarios/service/google_sheets_service.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:congresso_terciarios/view/qr_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Congresso Terciarios',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => QrScannerView());
                  },
                  child: const Text("Scan QR"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      GoogleSheetsService service = await GoogleSheetsService().init();
                      await service.getAllData();
                    },
                    child: const Text("Read Data Clout")),
                ElevatedButton(
                    onPressed: () async {
                      StorageService.readUsers("db");
                      StorageService.readEvent("db");
                    },
                    child: const Text("Read Data Storage")),
              ],
            ),
          ),
        ));
  }
}
