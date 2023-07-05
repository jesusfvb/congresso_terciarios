import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  static showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      name: "loading",
      barrierDismissible: false,
    );
  }

  static showErrorNetworkSnackbar() {
    Get.snackbar(
      '',
      '',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 0,
      maxWidth: Get.width,
      margin: const EdgeInsets.all(0),
      titleText: Container(),
      messageText: const Center(
        child: Text(
          'Error de conexión',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
