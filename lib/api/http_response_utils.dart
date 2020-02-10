import 'dart:convert';
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

  ErrorResponse({this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'],
    );
  }
}

String getErrorMessage(http.Response response) {
  final data = ErrorResponse.fromJson(json.decode(response.body));

  return data.message;
}
