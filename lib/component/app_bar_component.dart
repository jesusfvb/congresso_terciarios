import 'package:congresso_terciarios/component/dropdown_component.dart';
import 'package:congresso_terciarios/component/icon_component.dart';
import 'package:congresso_terciarios/component/icon_component.dart';
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
  final EventState eventState = Get.find();

  AppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        const DropdownComponent(),
        Obx(
          () => IconComponent.iconAppBar(
              disable: eventState.selectedEvent == null,
              icon: Icons.qr_code_scanner,
              onPressed: () {
                Get.to(QrScannerView());
              }),
        ),
        IconComponent.iconAppBar(
            icon: Icons.sync,
            onPressed: () async {
              NotificationService.showLoadingDialog();
              var isError = await _googleSheetsService.update();
              Get.back();
              if (!isError) NotificationService.showErrorNetworkSnackbar();
            }),
        IconComponent.iconAppBar(
            icon: Icons.more_vert_rounded,
            onPressed: () {
              Widget Function()? page;
              showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(Get.width, 0, 0, 0),
                  items: [
                    PopupMenuItem(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.info, color: Colors.blue, size: 30),
                            Text("Acerca de"),
                          ],
                        ),
                        onTap: () => page = () => const AboutView()),
                  ]).whenComplete(() => page != null ? Get.to(() => page!()) : null);
            }),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
