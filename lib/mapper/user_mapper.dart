import 'package:congresso_terciarios/dto/user_dto.dart';
import 'package:get/get.dart';

class UserMapper {
  static Map<String, UserDto> fromRowListToMap(List<List<String>> rows) {
    Map<String, UserDto> users = {};
    var epoch = DateTime(1899, 12, 30);
    for (var row in rows) {
      if (row.length < 3) continue;
      if (row[3].isEmpty) continue;
      if (row.isNotEmpty) {
        var date = row[1];
        if (date.isNotEmpty && !date.contains("/")) {
          var temp = epoch.add(int.parse(date).days);
          date = "${temp.day}/${temp.month}/${temp.year}";
        }
        users[row[3]] = UserDto(row[3], row[0], date, row[2], row.length <= 4 ? "" : row[4],
            row.length <= 5 ? "" : row[5]);
      }
    }
    return users;
  }
}
