import 'package:congresso_terciarios/component/dropdown_component.dart';
import 'package:congresso_terciarios/state/user_state.dart';
import 'package:congresso_terciarios/view/qr_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/google_sheets_service.dart';
import '../state/event_state.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final GoogleSheetsService _googleSheetsService = Get.find();

  final EventState _eventState = Get.put(EventState());
  final UserState _userState = Get.put(UserState());

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
              var update = await _googleSheetsService.update();
              if (update) {
                _userState.refresh();
                _eventState.refresh();
              }
            }),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
