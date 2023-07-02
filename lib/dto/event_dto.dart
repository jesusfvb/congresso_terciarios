import 'package:hive/hive.dart';

part 'event_dto.g.dart';

@HiveType(typeId: 2)
class EventDto {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<String> users;

  EventDto(this.name, this.users);
}
