import 'package:congresso_terciarios/dto/event_dto.dart';
import 'package:congresso_terciarios/dto/user_dto.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  static void saveUsers(String key, Map<String, UserDto> users) {
    _box.write("${key}_user", users);
  }

  static void readUsers(String key) {
    var users = _box.read<Map<String, UserDto>>("${key}_user");
    // TODO: print users
    print(users);
  }

  static void saveEvent(String key, Map<String, EventDto> event) {
    _box.write("${key}_event", event);
  }

  static void readEvent(String key) {
    var event = _box.read<Map<String, EventDto>>("${key}_event");
    // TODO: print users
    print(event);
  }
}
