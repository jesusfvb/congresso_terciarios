import 'package:congresso_terciarios/dto/user_dto.dart';

class UserMapper {
  static Map<String, UserDto> fromRowListToMap(List<List<String>> rows) {
    Map<String, UserDto> users = {};
    for (var row in rows) {
      users[row[3]] = UserDto(row[3], row[0], row[1], row[2], row[4], row[5]);
    }
    return users;
  }

  static List<UserDto> fromMapToList(Map<String, UserDto> users) {
    return users.values.toList();
  }
}
