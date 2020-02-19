import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';
import 'package:kedul_app_main/auth/user_entity.dart';

class UserRepository {
  APIClient _apiClient;

  UserRepository(this._apiClient);

  Future<User> getCurrentUser() async {
    http.Response response = await _apiClient.get('/auth/current_user');

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message, code: data.code);
    }

    User user = User.fromJson(json.decode(response.body));

    return user;
  }

  Future<User> updatePhoneNumberVerify() async {
    return null;
  }

  Future<User> updatePhoneNumberCheck() async {
    return null;
  }

  Future<User> updateUserProfile() async {
    return null;
  }
}
