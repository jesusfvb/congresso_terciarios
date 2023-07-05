import 'package:congresso_terciarios/component/dropdown_component.dart';
import 'package:congresso_terciarios/view/qr_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/google_sheets_service.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final GoogleSheetsService _googleSheetsService = Get.find();

  AppBarComponent({super.key});

  static Container _icon({required IconData icon, VoidCallback? onPressed}) => Container(
        margin: const EdgeInsets.only(right: 1),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: Colors.blue,
          iconSize: 30,
          splashRadius: 30,
        ),
      );

  @override
  Widget build(BuildContext context) {
    _googleSheetsService.context = context;

    return AppBar(
      actions: [
        const DropdownComponent(),
        _icon(
            icon: Icons.qr_code_scanner,
            onPressed: () {
              Get.to(QrScannerView());
            }),
        _icon(
            icon: Icons.sync,
            onPressed: () async {
              await _googleSheetsService.update();
            }),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
