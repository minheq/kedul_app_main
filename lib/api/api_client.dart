import 'package:http/http.dart' as http;

class APIClient {
  final http.Client client = http.Client();
  final String baseURL;

  APIClient({this.baseURL = "http://localhost:4000"});

  Future<http.Response> get(String url) {
    return client.get(url);
  }

  Future<http.Response> post(String url, String body) {
    return client.post(baseURL + url,
        headers: {'Content-Type': 'application/json'}, body: body);
  }
}
