import 'package:shared_preferences/shared_preferences.dart';

class StorageModel {
  Future<void> write(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setString(key, value);
  }

  Future<String> read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }
}
