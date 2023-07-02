import 'package:congresso_terciarios/state/dropdown_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownComponent extends StatelessWidget {
  const DropdownComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final DropdownState state = Get.put(DropdownState());

    return Obx(
      () => Expanded(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 20),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                  label: state.selectedEvent == null ? const Text("Eventos") : null,
                  border: InputBorder.none,
                ),
                value: state.selectedEvent,
                items: state.events.map((String event) {
                  return DropdownMenuItem(
                    value: event,
                    child: Text(event),
                  );
                }).toList(),
                onChanged: (value) {
                  state.setEvents(value!);
                }),
          ),
        ),
      ),
    );
  }
}
