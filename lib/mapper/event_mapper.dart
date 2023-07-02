import 'package:congresso_terciarios/dto/event_dto.dart';

class EventMapper {
  static Map<String, EventDto> fromListToMap(List<String> events) {
    Map<String, EventDto> exit = {};
    for (var event in events) {
      exit[event] = EventDto(event, []);
    }
    return exit;
  }
}
