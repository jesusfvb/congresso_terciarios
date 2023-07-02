import 'package:congresso_terciarios/dto/event_dto.dart';

class EventMapper {
  static Map<String, EventDto> fromListToMap(List<String> events) {
    Map<String, EventDto> exit = {};
    for (var event in events) {
      exit[event] = EventDto(event, []);
    }
    return exit;
  }

  static List<EventDto> fromMapToList(Map<String, EventDto> events) {
    List<EventDto> exit = [];
    events.forEach((key, value) {
      exit.add(value);
    });
    return exit;
  }

  static EventDto fromJsonToEventDto(Map<String, dynamic> json) {
    return EventDto(json['name'], json['users']);
  }
}
