import 'package:flutter/material.dart';

class BottomNavigationBarCameraComponent extends StatelessWidget {
  final VoidCallback? onBackPressed ;
  final VoidCallback? onToggleFlashPressed ;
  const BottomNavigationBarCameraComponent({super.key, this.onBackPressed, this.onToggleFlashPressed});


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: onBackPressed,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.lightBlue,
              )),
          IconButton(
              color: Colors.lightBlue,
              onPressed: onToggleFlashPressed,
              icon: const Icon(Icons.flash_on)),
        ],
      ),
    );
  }
}
