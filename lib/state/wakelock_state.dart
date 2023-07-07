import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

class WakelockState extends GetxController {
  final RxBool _state = false.obs;

  void active() {
    Wakelock.enable();
    _state.value = true;
  }

  void inactive() {
    Wakelock.disable();
    _state.value = false;
  }

  get state => _state.value;
}
