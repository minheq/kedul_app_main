import 'package:http/http.dart' as http;

class APIClient {
  final http.Client _client = http.Client();
  final String baseURL;

  APIClient(this.baseURL);

  Future<http.Response> get(String url) {
    return _client.get(url);
  }

  Future<http.Response> post(String url, String body) {
    return _client.post(baseURL + url,
        headers: {'Content-Type': 'application/json'}, body: body);
  }
}
