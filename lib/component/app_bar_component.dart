import 'dart:async';

import 'package:congresso_terciarios/component/dropdown_component.dart';
import 'package:congresso_terciarios/component/icon_component.dart';
import 'package:congresso_terciarios/view/about_view.dart';
import 'package:congresso_terciarios/view/qr_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/google_sheets_service.dart';
import '../service/notification_service.dart';
import '../state/event_state.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final GoogleSheetsService _googleSheetsService = Get.find();
  final EventState _eventState = Get.find();

  AppBarComponent({super.key});

  PopupMenuItem _menuItem({
    required String text,
    required IconData iconData,
    void Function()? onTap,
    required String value,
    Color color = Colors.blue,
  }) =>
      (PopupMenuItem(
          onTap: onTap,
          value: value,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(iconData, color: color, size: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text),
              ),
            ],
          )));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        const DropdownComponent(),
        Obx(
          () => IconComponent.iconAppBar(
              disable: _eventState.selectedEvent == null,
              icon: Icons.qr_code_scanner,
              onPressed: () {
                Get.to(() => QrScannerView());
              }),
        ),
        IconComponent.iconAppBar(
            icon: Icons.sync,
            onPressed: () async {
              NotificationService.showLoadingDialog();
              var isNotError = await _googleSheetsService.upload();
              if (isNotError) {
                isNotError = await _googleSheetsService.download();
              }
              Get.back();
              if (!isNotError) NotificationService.showErrorNetworkSnackbar();
            }),
        PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.blueAccent,
              size: 30,
            ),
            splashRadius: 30,
            itemBuilder: (context) => [
                  _menuItem(
                    text: "Acerca de",
                    value: "about",
                    iconData: Icons.info,
                  ),
                ])
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
