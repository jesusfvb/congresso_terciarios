import 'package:congresso_terciarios/dto/event_dto.dart';

class EventMapper {
  static Map<String, EventDto> fromListToMap(List<String> events) {
    Map<String, EventDto> exit = {};
    var i = 0;
    for (var event in events) {
      exit[event] = EventDto(event, [], i + 6);
      i++;
    }
    return exit;
  }
}
