import 'package:congresso_terciarios/component/dropdown_component.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends AppBar {
  AppBarComponent({super.key})
      : super(
          actions: [const DropdownComponent()],
          backgroundColor: Colors.white,
          elevation: 0,
        );
}
