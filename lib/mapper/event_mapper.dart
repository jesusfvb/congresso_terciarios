import 'package:congresso_terciarios/dto/event_dto.dart';

class EventMapper {
  static Map<String, EventDto> fromList(List<String> events) {
    Map<String, EventDto> exit = {};
    events.forEach((event) {
      exit[event] = EventDto(event, []);
    });
    return exit;
  }
}
