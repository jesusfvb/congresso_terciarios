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
            onSelected: (value) async {
              switch (value) {
                case "about":
                  Get.to(() => const AboutView());
                  break;
                case "delete":
                  NotificationService.showLoadingDialog();
                  Timer(0.5.seconds, () async {
                    await _eventState.clearAssists();
                    Get.back();
                  });
                  break;
                case "download":
                  NotificationService.showLoadingDialog();
                  var isError = await _googleSheetsService.download();
                  Get.back();
                  if (!isError) NotificationService.showErrorNetworkSnackbar();
                  break;
                case "upload":
                  NotificationService.showLoadingDialog();
                  var isError = await _googleSheetsService.upload();
                  Get.back();
                  if (!isError) NotificationService.showErrorNetworkSnackbar();
                  break;
              }
            },
            itemBuilder: (context) => [
                  _menuItem(
                    text: "Subir",
                    iconData: Icons.arrow_upward,
                    value: "upload",
                  ),
                  _menuItem(
                    value: "download",
                    text: "Bajar",
                    iconData: Icons.arrow_downward,
                  ),
                  _menuItem(
                    text: "Borrar",
                    value: "delete",
                    iconData: Icons.delete,
                    color: Colors.red,
                  ),
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
