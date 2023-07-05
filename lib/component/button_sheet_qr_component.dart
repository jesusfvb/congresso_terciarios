import 'package:audioplayers/audioplayers.dart';
import 'package:congresso_terciarios/dto/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonSheetQrDataComponent extends StatelessWidget {
  final UserDto? user;

  ButtonSheetQrDataComponent({Key? key, this.user}) : super(key: key);

  var listElement = (String title, String value) => Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        height: 400,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Presencia confirmada",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 30),
                ),
                Icon(
                  Icons.check,
                  color: Colors.greenAccent,
                  size: 50,
                ),
              ],
            ),
            const Divider(
              color: Colors.lightBlue,
              thickness: 2,
            ),
            listElement("Nombre:", user!.name),
            listElement("Turn:", user!.turn),
            listElement("Language:", user!.language),
            listElement("Status:", user!.status),
            listElement("Sodalício:", user!.sodalicio),
            listElement("Id:", user!.id),
          ],
        ),
      ),
    );
  }
}

class ButtonSheetQrErrorComponent extends StatelessWidget {
  ButtonSheetQrErrorComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        height: 300,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 100,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                "Usuario No Encontrado",
                style: TextStyle(color: Colors.redAccent, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
