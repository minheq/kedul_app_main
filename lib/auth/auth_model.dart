import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/auth/user_model.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';

class LoginVerifyBody {
  LoginVerifyBody({this.phoneNumber, this.countryCode});

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

class LoginVerifyData {
  final String verificationID;

  LoginVerifyData({this.verificationID});

  factory LoginVerifyData.fromJson(Map<String, dynamic> json) {
    return LoginVerifyData(
      verificationID: json['verificationID'],
    );
  }
}

class LoginVerifyCheckBody {
  LoginVerifyCheckBody({this.verificationID, this.code});

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

class LoginVerifyCheckData {
  final String accessToken;

  LoginVerifyCheckData({this.accessToken});

  factory LoginVerifyCheckData.fromJson(Map<String, dynamic> json) {
    return LoginVerifyCheckData(
      accessToken: json['accessToken'],
    );
  }
}

class AuthModel extends ChangeNotifier {
  UserModel userModel;
  APIClient apiClient;

  AuthModel({@required this.apiClient});

  void setUserModel(UserModel userModel) {
    this.userModel = userModel;
  }

  bool get isAuthenticated {
    return userModel.isAuthenticated;
  }

  Future<User> get currentUser async {
    return userModel.currentUser;
  }

  // Returns verificationID string use for further confirmation
  Future<String> loginVerify(String phoneNumber, String countryCode) async {
    String body =
        LoginVerifyBody(phoneNumber: phoneNumber, countryCode: countryCode)
            .toJson();

    final response = await apiClient.post('/login_verify', body);

    if (isErrorResponse(response)) {
      final data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    final data = LoginVerifyData.fromJson(json.decode(response.body));

    return data.verificationID;
  }

  Future<String> loginVerifyCheck(String verificationID, String code) async {
    String body =
        LoginVerifyCheckBody(verificationID: verificationID, code: code)
            .toJson();

    final response = await apiClient.post('/login_verify_check', body);

    if (isErrorResponse(response)) {
      final data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    final data = LoginVerifyCheckData.fromJson(json.decode(response.body));

    return data.accessToken;
  }

  void logOut() {}
}
