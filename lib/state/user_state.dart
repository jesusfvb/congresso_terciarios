import 'package:congresso_terciarios/service/google_sheets_service.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:get/get.dart';

import '../dto/user_dto.dart';

class UserState extends GetxController {
  final StorageService _storageService = Get.find();
  final GoogleSheetsService _googleSheetsService = Get.find();

  final RxMap<String, UserDto> _users = RxMap({});

  @override
  void onInit() async {
    super.onInit();
    var users = _storageService.readUsers("db");
    if (users == null && await _googleSheetsService.getAllData()) {
      users = _storageService.readUsers("db");
      _users.value = users!;
    } else {
      _users.value = users!;
    }
  }

  @override
  void refresh() {
    onInit();
  }

  UserDto? getUserById(String id) {
    return _users.value[id];
  }

  List<List> get users => _users.value.values.map((e) => [e.id, e.name]).toList();
}
