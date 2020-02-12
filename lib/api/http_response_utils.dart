import 'package:http/http.dart' as http;

bool isBadRequest(http.Response response) {
  if (response.statusCode == 400) {
    return true;
  }

  return false;
}

bool isUnauhorized(http.Response response) {
  if (response.statusCode == 401) {
    return true;
  }

  return false;
}

bool isNotFound(http.Response response) {
  if (response.statusCode == 404) {
    return true;
  }

  return false;
}

bool isServerError(http.Response response) {
  if (response.statusCode == 500) {
    return true;
  }

  return false;
}

bool isErrorResponse(http.Response response) {
  return isBadRequest(response) ||
      isUnauhorized(response) ||
      isNotFound(response) ||
      isServerError(response);
}

class ErrorResponse {
  final String message;
  final String code;
  final String docURL;

  ErrorResponse({this.message, this.code, this.docURL});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'],
      code: json['code'],
      docURL: json['doc_url'],
    );
  }
}
