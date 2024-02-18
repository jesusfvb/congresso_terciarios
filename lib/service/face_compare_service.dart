import 'package:congresso_terciarios/generated/assets.dart';
import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceCompareService {
  late Interpreter _interprete;

  void _configure(Function code) async {
    final interpreterOptions = InterpreterOptions();

    if (GetPlatform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate
    if (GetPlatform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }
    _interprete = await Interpreter.fromAsset(Assets.iaMobileFaceNet, options: interpreterOptions);
    code();
    _interprete.close();
  }

  bool isTheSameFace() {
    var salida = false;
    _configure(() {});
    return salida;
  }
}
