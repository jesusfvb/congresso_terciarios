import 'dart:io';

import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'storage_service.dart';

class CsvService {
  final StorageService _storageService = Get.find();

  List<List<String>> _createCsv() {
    var users = _storageService.readUsers("db");
    var events = _storageService.readEvents("db");
    if (users != null && events != null) {
      List<String> header = [
        "Nome",
        "Turn",
        "Lenguage",
        "ID",
        "Status",
        "Sodalício",
        ...events.keys.toList()
      ];
      List<List<String>> data = users.values.map((value) {
        List<String> event = events.keys.map((key) {
          if (events[key]!.users.contains(value.id)) {
            return "X";
          }
          return "";
        }).toList();
        return [
          value.name,
          value.turn,
          value.language,
          value.id,
          value.status,
          value.sodalicio,
          ...event
        ];
      }).toList();
      return [header, ...data];
    }
    return [];
  }

  Future _saveFile(String csv) async {
    var dir = await getExternalStorageDirectory();
    if (dir != null && dir.existsSync()) {
      print(dir.path);
      var file = File('${dir.path}/congreso.csv');
      await file.writeAsString(csv);
    }
  }

  Future _shareFile() async {
    var dir = await getExternalStorageDirectory();
    if (dir != null && dir.existsSync()) {
      var file = File('${dir.path}/congreso.csv');
      await Share.shareFiles(['${dir.path}/congreso.csv'], mimeTypes: ['text/csv']);
    }
  }

  void exportCsv() async {
    var csvArray = _createCsv();
    var csv = const ListToCsvConverter().convert(csvArray);
    await _saveFile(csv);
    await _shareFile();
  }
}
