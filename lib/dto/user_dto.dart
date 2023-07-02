import 'package:hive/hive.dart';

part 'user_dto.g.dart';

@HiveType(typeId: 1)
class UserDto {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String turn;
  @HiveField(3)
  late String language;
  @HiveField(4)
  late String status;
  @HiveField(5)
  late String sodalicio;

  UserDto(
    this.id,
    this.name,
    this.turn,
    this.language,
    this.status,
    this.sodalicio,
  );
}
