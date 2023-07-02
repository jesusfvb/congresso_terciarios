import 'package:congresso_terciarios/component/app_bar_component.dart';
import 'package:congresso_terciarios/dto/event_dto.dart';
import 'package:congresso_terciarios/dto/user_dto.dart';
import 'package:congresso_terciarios/service/google_sheets_service.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:congresso_terciarios/view/qr_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  Hive.registerAdapter(UserDtoAdapter());
  Hive.registerAdapter(EventDtoAdapter());
  await Hive.initFlutter();
  await Hive.openBox('db');

  Get.put(StorageService());
  Get.put(await GoogleSheetsService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GoogleSheetsService googleSheetsService = Get.find();
    StorageService storageService = Get.find();

    return GetMaterialApp(
        title: 'Congresso Terciarios',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBarComponent(),
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
                      await googleSheetsService.getAllData();
                    },
                    child: const Text("Read Data Clout")),
                ElevatedButton(
                    onPressed: () async {
                      // storageService.readUsers("db");
                      print(storageService.readEvent("db"));
                    },
                    child: const Text("Read Data Storage")),
              ],
            ),
          ),
        ));
  }
}
