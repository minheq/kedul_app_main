import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/auth/user_model.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';
import 'package:kedul_app_main/storage/secure_storage_model.dart';

class AuthModel extends ChangeNotifier {
  UserModel _userModel;
  final APIClient _apiClient;
  final SecureStorageModel _secureStorageModel;

  AuthModel(this._apiClient, this._secureStorageModel);

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  bool get isAuthenticated {
    return _userModel.isAuthenticated;
  }

  Future<User> get currentUser async {
    return _userModel.currentUser;
  }

  // Returns verificationID string use for further confirmation
  Future<String> loginVerify(String phoneNumber, String countryCode) async {
    String body =
        _LoginVerifyBody(phoneNumber: phoneNumber, countryCode: countryCode)
            .toJson();

    final response = await _apiClient.post('/login_verify', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      final data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    final data = _LoginVerifyData.fromJson(json.decode(response.body));

    return data.verificationID;
  }

  Future<String> loginVerifyCheck(String verificationID, String code) async {
    String body =
        _LoginVerifyCheckBody(verificationID: verificationID, code: code)
            .toJson();

    final response = await _apiClient.post('/login_verify_check', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      final data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    final data = _LoginVerifyCheckData.fromJson(json.decode(response.body));

    await _secureStorageModel.write('access_token', data.accessToken);

    return data.accessToken;
  }

  void logOut() {}
}

class _LoginVerifyBody {
  _LoginVerifyBody({this.phoneNumber, this.countryCode});

  String phoneNumber;
  String countryCode;

  String toJson() {
    var mapData = new Map();

    mapData['phoneNumber'] = phoneNumber;
    mapData['countryCode'] = countryCode;

    String body = json.encode(mapData);

    return body;
  }
}

class _LoginVerifyData {
  final String verificationID;

  _LoginVerifyData({this.verificationID});

  factory _LoginVerifyData.fromJson(Map<String, dynamic> json) {
    return _LoginVerifyData(
      verificationID: json['verificationID'],
    );
  }
}

class _LoginVerifyCheckBody {
  _LoginVerifyCheckBody({this.verificationID, this.code});

  String verificationID;
  String code;

  String toJson() {
    var mapData = new Map();

    mapData['verificationID'] = verificationID;
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
      accessToken: json['accessToken'],
    );
  }
}
