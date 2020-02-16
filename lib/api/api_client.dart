import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kedul_app_main/storage/secure_storage_model.dart';

class APIClient {
  final http.Client _client = http.Client();
  final String _baseURL;
  final SecureStorageModel _secureStorage;

  APIClient(this._baseURL, this._secureStorage);

  Future<String> _getAccessToken() async {
    String accessToken = await _secureStorage.read('access_token');

    return accessToken;
  }

  Future<http.Response> get(String pathname) async {
    String accessToken = await _getAccessToken();

    return _client.get(_baseURL + pathname,
        headers: {HttpHeaders.authorizationHeader: "Basic $accessToken"});
  }

  Future<http.Response> post(String pathname, String body) async {
    String accessToken = await _getAccessToken();

    return _client.post(_baseURL + pathname,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Basic $accessToken"
        },
        body: body);
  }
}
