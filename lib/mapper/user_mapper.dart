import 'package:congresso_terciarios/dto/user_dto.dart';

class UserMapper {
  static Map<String, UserDto> fromRowListToMap(List<List<String>> rows) {
    Map<String, UserDto> users = {};
    for (var row in rows) {
      if (row.isNotEmpty) {
        users[row[3]] = UserDto(row[3], row[0], row[1], row[2], row.length <= 4 ? "" : row[4],
            row.length <= 5 ? "" : row[5]);
      }
    }
    return users;
  }
}
