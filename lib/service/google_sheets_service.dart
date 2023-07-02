import 'package:congresso_terciarios/mapper/user_mapper.dart';
import 'package:congresso_terciarios/service/storage_service.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';

import '../mapper/event_mapper.dart';

class GoogleSheetsService {
  final StorageService _storageService = Get.find();

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
  final _gsheets = GSheets(_credentials);

  Worksheet? _worksheet;

  Future<GoogleSheetsService> init() async {
    final allshet = await _gsheets.spreadsheet(_idSheets);
    _worksheet = allshet.worksheetByIndex(0);
    return this;
  }

  Future getAllData() async {
    final allRows = await _worksheet!.values.allRows();
    final events = EventMapper.fromListToMap(allRows.first.sublist(6));
    final users = UserMapper.fromRowListToMap(allRows.sublist(1));
    await _storageService.saveUsers("db", users);
    print("users saved");
    await _storageService.saveEvents("db", events);
    print("events saved");
  }
}
