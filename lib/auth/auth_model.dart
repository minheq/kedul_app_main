import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';

import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';
import 'package:kedul_app_main/auth/user_repository.dart';
import 'package:kedul_app_main/storage/secure_storage_model.dart';

class AuthModel extends ChangeNotifier {
  User _currentUser;
  final APIClient _apiClient;
  final SecureStorageModel _secureStorageModel;
  final UserRepository _userRepository;
  final AnalyticsModel _analyticsModel;

  AuthModel(this._apiClient, this._secureStorageModel, this._userRepository,
      this._analyticsModel);

  bool get isAuthenticated {
    return _currentUser != null;
  }

  User get currentUser {
    return _currentUser;
  }

  Future<User> loadCurrentUser() async {
    try {
      User user = await _userRepository.getCurrentUser();
      _currentUser = user;

      return user;
    } on APIErrorException {
      return null;
    } catch (e, s) {
      _analyticsModel.recordError(e, s);

      return null;
    }
  }

  // Returns verificationID string use for further confirmation
  Future<String> loginVerify(String phoneNumber, String countryCode) async {
    String body =
        _LoginVerifyBody(phoneNumber: phoneNumber, countryCode: countryCode)
            .toJson();

    http.Response response = await _apiClient.post('/auth/login_verify', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    _LoginVerifyData data =
        _LoginVerifyData.fromJson(json.decode(response.body));

    return data.verificationID;
  }

  Future<String> loginVerifyCheck(String verificationID, String code) async {
    String body =
        _LoginVerifyCheckBody(verificationID: verificationID, code: code)
            .toJson();

    http.Response response = await _apiClient.post('/auth/login_check', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    _LoginVerifyCheckData data =
        _LoginVerifyCheckData.fromJson(json.decode(response.body));

    await _secureStorageModel.write('access_token', data.accessToken);

    return data.accessToken;
  }

  Future<void> logOut() async {
    await _secureStorageModel.remove('access_token');
    _currentUser = null;
  }
}

class _LoginVerifyBody {
  _LoginVerifyBody({this.phoneNumber, this.countryCode});

  String phoneNumber;
  String countryCode;

  String toJson() {
    var mapData = new Map();

    mapData['phone_number'] = phoneNumber;
    mapData['country_code'] = countryCode;

    String body = json.encode(mapData);

    return body;
  }
}

class _LoginVerifyData {
  final String verificationID;

  _LoginVerifyData({this.verificationID});

  factory _LoginVerifyData.fromJson(Map<String, dynamic> json) {
    return _LoginVerifyData(
      verificationID: json['verification_id'],
    );
  }
}

class _LoginVerifyCheckBody {
  _LoginVerifyCheckBody({this.verificationID, this.code});

  String verificationID;
  String code;

  String toJson() {
    var mapData = new Map();

    mapData['verification_id'] = verificationID;
    mapData['code'] = code;

    String body = json.encode(mapData);

    return body;
  }
}

class _LoginVerifyCheckData {
  final String accessToken;

  _LoginVerifyCheckData({this.accessToken});

  factory _LoginVerifyCheckData.fromJson(Map<String, dynamic> json) {
    return _LoginVerifyCheckData(
      accessToken: json['access_token'],
    );
  }
}
