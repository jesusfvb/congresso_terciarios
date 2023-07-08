import 'package:congresso_terciarios/dto/event_dto.dart';

class EventMapper {
  static Map<String, EventDto> fromListToMap(List<String> events) {
    Map<String, EventDto> exit = {};
    var i = 0;
    for (var event in events) {
      if (event == "@@MASTER@@") continue;
      exit[event] = EventDto(event, [], i + 7);
      i++;
    }
    return exit;
  }
}
