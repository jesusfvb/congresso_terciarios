import 'package:congresso_terciarios/state/event_state.dart';
import 'package:congresso_terciarios/state/user_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserState userState = Get.find();
    final EventState eventState = Get.find();

    FocusNode focusNode = FocusNode();

    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            onChanged: (value) {
              userState.search(value);
            },
            onTapOutside: (value) {
              focusNode.unfocus();
            },
            onEditingComplete: () {
              focusNode.unfocus();
            },
            focusNode: focusNode,
            autofocus: false,
            decoration: const InputDecoration(
              labelText: 'Buscar',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            var users = userState.users;
            return Container(
              margin: const EdgeInsets.all(15),
              child: ListView.separated(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Expanded(
                        child: Text(
                      user[1] as String,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    )),
                    Obx(() => (eventState.isInEventSelected(user[0])
                        ? const Icon(Icons.check)
                        : Container())),
                  ]);
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            );
          }),
        ),
      ],
    );
  }
}
