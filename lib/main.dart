import 'package:congresso_terciarios/view/qr_scanner.dart';
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
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => QRScanner());
                },
                child: const Text("Scan QR"),
              )),
        ));
  }
}
