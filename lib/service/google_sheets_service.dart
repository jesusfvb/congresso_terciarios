import 'package:congresso_terciarios/mapper/user_mapper.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:congresso_terciarios/state/event_state.dart';
import 'package:congresso_terciarios/state/user_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';

import '../mapper/event_mapper.dart';

class GoogleSheetsService {
  final StorageService _storageService = Get.find();
  final UserState _userState = Get.put(UserState());
  final EventState _eventState = Get.put(EventState());

  // email = congresso-terciarios@congressoterciarios.iam.gserviceaccount.com
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "congressoterciarios",
  "private_key_id": "c739a7f85beab80406c39c3b98724b6bbb73adcb",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/bqnyGVljmzsB\nqfE0z4uJhqnb00uK6Z8tav7V7LkHW78e0k+vOftAV/hNH7OXeG4s9oowqz7/5TmU\niE3vrtggRkoT2FvupsK4sna3cmh+wPJdqPqjs0XMbzRsVEzmJ8Qe5IbIXzf9qkoN\nXenc7U1lRMBcDp9/baZpYS5dkWT2Ut+x1GxPqxFmPGL1ZEqDCS4g94GQSSSHj/57\n1jkfmEsONWbmS+mM+RPIWvJN70/LIMwPEdn1GEJzs4oNo/hC+mfYnAemqQiMDiZo\nCS394CQ0POlPxaoOUh0wQlfL9pvegfmoWyW5YU4F34L0rpeV/g0UPVcX3ejzi4m0\nn42MXduxAgMBAAECggEAAholVEWXqAgGBNr94sDosluVNUHDvERxKAmFv4mi79lq\nZtyTssPl5hX74bTtvvBmnVMeagcSC7NTsjWGTZHTnmnHLyKawoB4S5jsxCTwetEu\n7X0JNjpQvjxLt2jRk1wabjsU3nxqhqbpEJktvpb92OqBW5bEL50KTRvxFhFI/4od\nMQIbzXtFnvtFe8y/LI7rd1VeJAXu4td0Iu1oipu39kWy5EetE0JoOrW4FxjYa/dK\ngM7W+RGBq6sNev0YHiqIySU8GGe18SfltUKPyt0D1hrph8yEzHWYW9VGzFUbdvkL\n/COCUixCJs+mCMwiPj4/nUHutbbznetH3MuHVZfARQKBgQD+6jNNTGfj9iWy/IQJ\npuJjJ5iofkfWDVpkKplfKbPCM0w+vDH8wp4x+W6k32GGV/aqfF8Bs8j4utok9OXw\nRVR4nYTbFWqDRSrerY8S0st/OfICXysGtnIkid8Xlxoe6IUPml640c1gDIveX2V0\n22Q+Pcs3VFgCUCTnjE6zTXeekwKBgQDAP0gjyGxnkTV4N6NQ4J+6o7N1kRbrT8IA\nZF8SKIy0uwRAesQwSBu+5/XcBcIDBmqWNs0CQ0YDdub6XaqMG4ip+rKoIWFB+YQ7\nk/aW7SKf1hk7HHVuOuvksiM71vwZzhV5WAmKx5gVMm5+1jRAmAolzyMMFmhgdYyn\nlb0QY/uDKwKBgCsA94aizSP38oQvdVbrgGWZ2HcUVqoVtpoPVbBoKJsqbEJpHUW2\nz1k+6xuFU76GOGaqdJyk59KOMx7o8aGHEKkIadFL25wpnwHR5cEXLp1X+SvNQkTv\nonHnkGs6Yn20XD41nKUxP6RkeXQaQ9Ni75ZQdmfvIqnBO3iUgvJcr0FhAoGABBMT\nR1bfHU7RkEu1lWg9WmpPymUZ1EDrfrCh5zOez9HK5Eb104QjumcWKeShWQkQx0BA\nFhUw7a/ec1362F9ZBSlAEhorAof0SoL3TfmWq0aRYFRZFM4A4+b2ojULQMzCXcEE\n6sESMxjPiLangtr2FBkQyBfNfIXhRkgBKtDDquMCgYEAuzNJszlBhEyiC6SYr2E0\n13ohZlGF17T+OV7s/ujg625/798Pk0gDgmWCI/Lun3SJNsL0RzGpbNTz2x2lU/r3\nE/c3FqtfUVWvMmKS+QqtowvMOUh5iygHRAfZ1EYeiu4msEAIybI5Em9Pg/x8oXMs\nBXGrIMRVidm2dHR+fFZRjDI=\n-----END PRIVATE KEY-----\n",
  "client_email": "congresso-terciarios@congressoterciarios.iam.gserviceaccount.com",
  "client_id": "115851775118311107836",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/congresso-terciarios%40congressoterciarios.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';
  final _idSheets = "1nOYzaHD0kAqN_7gI4McZagyDvmt52ugbxfIqbouCWZ0";
  final _gSheets = GSheets(_credentials);

  Worksheet? _worksheet;
  BuildContext? _context;

  set context(BuildContext context) {
    _context = context;
  }

  Future<GoogleSheetsService> init() async {
    await _init(message: false);
    return this;
  }

  Future<bool> getAllData({bool message = false}) async {
    if (!await _init()) {
      return false;
    }
    try {
      final allRows = await _worksheet!.values.allRows();
      final eventList = allRows.first.sublist(6);
      final events = EventMapper.fromListToMap(eventList);
      final usersList = allRows.sublist(1);
      final users = UserMapper.fromRowListToMap(usersList);

      for (var user in usersList) {
        String id = user[3];
        var assistance = user.sublist(6);
        var cont = 0;
        for (var check in assistance) {
          if (check == "X" || check == "x") {
            events[eventList[cont]]?.users.add(id);
          }
          cont++;
        }
      }

      await _storageService.saveUsers("db", users);
      _userState.refresh();
      await _storageService.saveEvents("db", events);
      _eventState.refresh();
      if (message) {
        showModalBottomSheet(
                context: _context!,
                builder: (context) {
                  return const SizedBox(
                      height: 50,
                      child: Center(
                          child: Text(
                        "Datos actualizados",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )));
                },
                barrierColor: Colors.transparent,
                backgroundColor: Colors.green)
            .timeout(0.5.seconds, onTimeout: () {
          Get.back();
        });
      }
      return true;
    } catch (e) {
      print("Error de connexion 2");
      _showErrorConnection();
      return false;
    }
  }

  Future<bool> update() async {
    if (!await _init()) {
      return false;
    }
    try {
      var events = _storageService.readEvents("db");
      if (events != null) {
        for (var event in events.values) {
          try {
            var indexColumn = await _worksheet?.values.columnIndexOf(event.name);
            for (var user in event.users) {
              try {
                var indexRow = await _worksheet?.values.rowIndexOf(user, inColumn: 4);
                await _worksheet?.values.insertValue("X", column: indexColumn!, row: indexRow!);
              } catch (e) {
                _showErrorConnection(text: "Error al actualizar los datos");
                getAllData();
                print("Error de connexion 5");
                return false;
              }
            }
          } catch (e) {
            _showErrorConnection();
            print("Error de connexion 4");
            return false;
          }
        }
      }
      return await getAllData(message: true);
    } catch (e) {
      _showErrorConnection();
      print("Error de connexion 3");
      return false;
    }
  }

  Future<bool> _init({message = true}) async {
    if (_worksheet != null) return true;
    try {
      final allshet = await _gSheets.spreadsheet(_idSheets);
      _worksheet = allshet.worksheetByIndex(0);
      return true;
    } catch (e) {
      if (message) _showErrorConnection();
      print("Error connexion 1");
      return false;
    }
  }

  void _showErrorConnection({String? text}) => showModalBottomSheet(
              context: _context!,
              builder: (context) {
                return SizedBox(
                    height: 50,
                    child: Center(
                        child: Text(
                      text ?? "Error de Connexion",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )));
              },
              barrierColor: Colors.transparent,
              backgroundColor: Colors.red)
          .timeout(0.5.seconds, onTimeout: () {
        Get.back();
      });
}
