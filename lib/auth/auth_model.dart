import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';
import 'package:kedul_app_main/storage/secure_storage_model.dart';

class User {
  final String id;
  final String emailAddress;
  final String phoneNumber;
  final String countryCode;
  final String fullName;
  final String profileImageID;

  User(
      {this.id,
      this.emailAddress,
      this.phoneNumber,
      this.countryCode,
      this.fullName,
      this.profileImageID});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      emailAddress: json['email_address'],
      phoneNumber: json['phone_number'],
      countryCode: json['country_code'],
      fullName: json['full_name'],
      profileImageID: json['profile_image_id'],
    );
  }
}

class AuthModel extends ChangeNotifier {
  User _currentUser;
  final APIClient _apiClient;
  final SecureStorageModel _secureStorageModel;
  final AnalyticsModel _analyticsModel;

  AuthModel(this._apiClient, this._secureStorageModel, this._analyticsModel);

  bool get isAuthenticated {
    return _currentUser != null;
  }

  User get currentUser {
    return _currentUser;
  }

  Future<User> loadCurrentUser() async {
    try {
      http.Response response = await _apiClient.get('/auth/current_user');

      if (HTTPResponseUtils.isErrorResponse(response)) {
        return null;
      }

      User user = User.fromJson(json.decode(response.body));

      _currentUser = user;

      return user;
    } catch (e, s) {
      _analyticsModel.recordError(e, s);

      return null;
    }
  }

  // Returns verificationID string use for further confirmation
  Future<String> loginVerify(String phoneNumber, String countryCode) async {
    String body = _PhoneNumberVerifyBody(
            phoneNumber: phoneNumber, countryCode: countryCode)
        .toJson();

    http.Response response = await _apiClient.post('/auth/login_verify', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    _PhoneNumberVerifyData data =
        _PhoneNumberVerifyData.fromJson(json.decode(response.body));

    return data.verificationID;
  }

  Future<String> loginCheck(String verificationID, String code) async {
    String body =
        _PhoneNumberCheckBody(verificationID: verificationID, code: code)
            .toJson();

    http.Response response = await _apiClient.post('/auth/login_check', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    _LoginCheckData data = _LoginCheckData.fromJson(json.decode(response.body));

    await _secureStorageModel.write('access_token', data.accessToken);

    return data.accessToken;
  }

  Future<void> logOut() async {
    await _secureStorageModel.remove('access_token');
    _currentUser = null;
  }

  Future<String> updatePhoneNumberVerify(
      String phoneNumber, String countryCode) async {
    String body = _PhoneNumberVerifyBody(
            phoneNumber: phoneNumber, countryCode: countryCode)
        .toJson();

    http.Response response =
        await _apiClient.post('/auth/update_phone_number_verify', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    _PhoneNumberVerifyData data =
        _PhoneNumberVerifyData.fromJson(json.decode(response.body));

    return data.verificationID;
  }

  Future<User> updatePhoneNumberCheck(
      String verificationID, String code) async {
    String body =
        _PhoneNumberCheckBody(verificationID: verificationID, code: code)
            .toJson();

    http.Response response =
        await _apiClient.post('/auth/update_phone_number_check', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    User user = User.fromJson(json.decode(response.body));

    _currentUser = user;

    notifyListeners();

    return user;
  }

  Future<User> updateUserProfile(String fullName, String profileImageID) async {
    String body = _UpdateUserProfileBody(
            fullName: fullName, profileImageID: profileImageID)
        .toJson();

    http.Response response =
        await _apiClient.post('/auth/update_user_profile', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    User user = User.fromJson(json.decode(response.body));

    _currentUser = user;

    notifyListeners();

    return user;
  }
}

class _UpdateUserProfileBody {
  _UpdateUserProfileBody({this.fullName, this.profileImageID});

  String fullName;
  String profileImageID;

  String toJson() {
    Map mapData = Map();

    mapData['full_name'] = fullName;
    mapData['profile_image_id'] = profileImageID;

    String body = json.encode(mapData);

    return body;
  }
}

class _PhoneNumberVerifyBody {
  _PhoneNumberVerifyBody({this.phoneNumber, this.countryCode});

  String phoneNumber;
  String countryCode;

  String toJson() {
    Map mapData = Map();

    mapData['phone_number'] = phoneNumber;
    mapData['country_code'] = countryCode;

    String body = json.encode(mapData);

    return body;
  }
}

class _PhoneNumberVerifyData {
  final String verificationID;

  _PhoneNumberVerifyData({this.verificationID});

  factory _PhoneNumberVerifyData.fromJson(Map<String, dynamic> json) {
    return _PhoneNumberVerifyData(
      verificationID: json['verification_id'],
    );
  }
}

class _PhoneNumberCheckBody {
  _PhoneNumberCheckBody({this.verificationID, this.code});

  String verificationID;
  String code;

  String toJson() {
    Map mapData = Map();

    mapData['verification_id'] = verificationID;
    mapData['code'] = code;

    String body = json.encode(mapData);

    return body;
  }
}

class _LoginCheckData {
  final String accessToken;

  _LoginCheckData({this.accessToken});

  factory _LoginCheckData.fromJson(Map<String, dynamic> json) {
    return _LoginCheckData(
      accessToken: json['access_token'],
    );
  }
}
