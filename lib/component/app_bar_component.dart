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
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        );
}
