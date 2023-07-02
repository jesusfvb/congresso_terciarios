import 'package:congresso_terciarios/dto/event_dto.dart';
import 'package:congresso_terciarios/mapper/event_mapper.dart';
import 'package:congresso_terciarios/service/google_sheets_service.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:get/get.dart';

class DropdownState extends GetxController {
  final StorageService _storageService = Get.find();
  final GoogleSheetsService _googleSheetsService = Get.find();

  final RxList<EventDto> _events = RxList<EventDto>();
  final Rx<EventDto?> _selectedEvent = Rx<EventDto?>(null);

  @override
  void onInit() async {
    super.onInit();
    var events = _storageService.readEvents("db");
    if (events == null) {
      events = await _googleSheetsService.getAllData();
      _storageService.readEvents("db");
    }
    _events.value = EventMapper.fromMapToList(events!);
    _selectedEvent.value = _storageService.readEvent("db");
  }

  void setEvents(String events) {
    var event = _events.firstWhere((event) => event.name == events);
    _storageService.saveEvent("db", event);
    _selectedEvent.value = event;
  }

  List<String> get events => _events.map((event) => event.name).toList();

  String? get selectedEvent => _selectedEvent.value?.name;
}
