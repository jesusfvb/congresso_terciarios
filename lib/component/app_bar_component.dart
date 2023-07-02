import 'package:congresso_terciarios/component/dropdown_component.dart';
import 'package:congresso_terciarios/view/qr_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppBarComponent extends AppBar {
  AppBarComponent({super.key})
      : super(
          actions: [
            const DropdownComponent(),
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () {
                  Get.to(QrScannerView());
                },
                icon: const Icon(Icons.qr_code_scanner),
                color: Colors.blue,
                iconSize: 35,
                splashRadius: 30,
              ),
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        );
}
