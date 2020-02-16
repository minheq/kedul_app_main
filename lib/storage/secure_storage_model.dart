import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageModel {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  Future<String> read(String key) async {
    return await storage.read(key: key);
  }
}
