import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dto/user_dto.dart';

class ButtonSheetHomeComponent extends StatelessWidget {
  final UserDto? user;

  ButtonSheetHomeComponent({Key? key, this.user}) : super(key: key);

  var listElement = (String title, String value) => Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        height: 380,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Participante",
                style: TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
            ),
            const Divider(
              color: Colors.blueAccent,
              thickness: 2,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(user!.name, style: const TextStyle(color: Colors.white, fontSize: 25))),
            ),
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
