import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/auth/user_model.dart';
import 'package:kedul_app_main/data/phone_number.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';

class LoginVerifyBody {
  LoginVerifyBody({this.phoneNumber});

  PhoneNumber phoneNumber;

  String toJson() {
    var mapData = new Map();

    mapData['phoneNumber'] = phoneNumber.phoneNumber;
    mapData['countryCode'] = phoneNumber.countryCode;

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
  Future<String> loginVerify(PhoneNumber phoneNumber) async {
    String body = LoginVerifyBody(phoneNumber: phoneNumber).toJson();

    final response = await apiClient.post('/login_verify', body);

    if (isErrorResponse(response)) {
      throw getErrorMessage(response);
    }

    final data = LoginVerifyData.fromJson(json.decode(response.body));

    return data.verificationID;
  }

  Future<String> loginVerifyCheck(String verificationID, String otpCode) async {
    return '';
  }

  void logOut() {}
}
