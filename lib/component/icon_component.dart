import 'package:flutter/material.dart';

class IconComponent {
  static Container iconAppBar({
    required IconData icon,
    VoidCallback? onPressed,
    bool disable = false,
    Key? key,
  }) =>
      Container(
        key: key,
        margin: const EdgeInsets.only(right: 1),
        child: IconButton(
          onPressed: !disable ? onPressed : null,
          icon: Icon(icon),
          color: Colors.blue,
          iconSize: 30,
          splashRadius: 30,
        ),
      );
}
