import 'package:congresso_terciarios/generated/assets.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceCompareService {
  late Interpreter _interprete;

  void _configure(Function code) async {
    _interprete = await Interpreter.fromAsset(Assets.iaMobileFaceNet);
    code();

    _interprete.close();
  }

  bool isTheSameFace() {
    var salida = false;
    _configure(() {

    });
    return salida;
  }
}
