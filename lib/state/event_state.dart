import 'package:congresso_terciarios/dto/event_dto.dart';
import 'package:congresso_terciarios/service/google_sheets_service.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:get/get.dart';

class EventState extends GetxController {
  final StorageService _storageService = Get.find();

  final RxMap<String, EventDto> _events = RxMap({});
  final Rx<EventDto?> _selectedEvent = Rx<EventDto?>(null);

  @override
  void onInit() async {
    super.onInit();
    _events.value = _storageService.readEvents("db") ?? {};
    var eventSelected = _storageService.readEvent("db");
    if (_events.value.containsKey(eventSelected?.name)) {
      _selectedEvent.value = eventSelected;
    } else {
      _selectedEvent.value = null;
    }
  }

  @override
  void refresh() {
    onInit();
  }

  void setSelectedEvents(String events) {
    var event = _events[events];
    _storageService.saveEvent("db", event!);
    _selectedEvent.value = event;
  }

  void saveParticipation(String idUser) {
    var event = _selectedEvent.value;
    if (event!.users.contains(idUser) == false) {
      event.users.add(idUser);
      _storageService.saveEvent("db", event);
      var events = _events.value;
      events[event.name] = event;
      _storageService.saveEvents("db", events);
      _selectedEvent.refresh();
    }
  }

  List<String> get events {
    return _events.value.values.map((e) => e.name).toList();
  }

  String? get selectedEvent => _selectedEvent.value?.name;

  EventDto get selectedEventDto => _selectedEvent.value!;

  bool isInEventSelected(String userId) => _selectedEvent.value?.users.contains(userId) ?? false;
}
