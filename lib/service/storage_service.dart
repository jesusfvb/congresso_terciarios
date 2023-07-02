import 'package:congresso_terciarios/dto/event_dto.dart';
import 'package:congresso_terciarios/dto/user_dto.dart';
import 'package:hive/hive.dart';

class StorageService {
  final _box = Hive.box('db');

  StorageService();

  Future saveUsers(String key, Map<String, UserDto> users) async {
    await _box.put("${key}_user", users);
  }

  Map<String, UserDto>? readUsers(String key) {
    return _box.get("${key}_user")?.cast<String, UserDto>();
  }

  Future saveEvents(String key, Map<String, EventDto> event) async {
    _box.put("${key}_events", event);
  }

  Map<String, EventDto>? readEvents(String key) {
    return _box.get("${key}_events")?.cast<String, EventDto>();
  }

  Future saveEvent(String key, EventDto event) async {
    _box.put("${key}_event", event);
  }

  EventDto? readEvent(String key) {
    return _box.get("${key}_event");
  }
}
