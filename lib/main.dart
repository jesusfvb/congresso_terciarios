import 'package:audioplayers/audioplayers.dart';
import 'package:congresso_terciarios/component/app_bar_component.dart';
import 'package:congresso_terciarios/dto/event_dto.dart';
import 'package:congresso_terciarios/dto/user_dto.dart';
import 'package:congresso_terciarios/service/google_sheets_service.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:congresso_terciarios/state/event_state.dart';
import 'package:congresso_terciarios/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  Hive.registerAdapter(UserDtoAdapter());
  Hive.registerAdapter(EventDtoAdapter());
  await Hive.initFlutter();
  await Hive.openBox('db');

  Get.put(StorageService());
  Get.put(await GoogleSheetsService().init());

  Get.put(EventState());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Congresso Terciarios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBarComponent(),
        body: const HomeView(),
      ),
    );
  }
}
