import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kedul_app_main/data/http_response_utils.dart';
import 'package:kedul_app_main/data/phone_number.dart';
import 'package:kedul_app_main/data/api_client.dart';

class User {
  String id;
  String emailAddress;
  String phoneNumber;
  String countryCode;
  String fullName;
  String profileImageID;
}

class LoginVerifyRequest {
  LoginVerifyRequest({this.phoneNumber});

  PhoneNumber phoneNumber;

  String toJson() {
    var mapData = new Map();

    mapData['phoneNumber'] = phoneNumber.phoneNumber;
    mapData['countryCode'] = phoneNumber.countryCode;

    String data = json.encode(mapData);

    return data;
  }
}

class LoginVerifyResponse {
  final String verificationID;

  LoginVerifyResponse({this.verificationID});

  factory LoginVerifyResponse.fromJson(Map<String, dynamic> json) {
    return LoginVerifyResponse(
      verificationID: json['verificationID'],
    );
  }
}

class AuthProvider extends ChangeNotifier {
  User currentUser;
  ApiClient apiClient = ApiClient();

  AuthProvider();

  bool get isAuthenticated {
    return currentUser != null;
  }

  // Returns verificationID string use for further confirmation
  Future<String> loginVerify(PhoneNumber phoneNumber) async {
    String body = LoginVerifyRequest(phoneNumber: phoneNumber).toJson();

    final response = await apiClient.post('/login_verify', body);

    if (isErrorResponse(response)) {
      throw getErrorMessage(response);
    }

    final data = LoginVerifyResponse.fromJson(json.decode(response.body));

    return data.verificationID;
  }

  Future<String> loginVerifyCheck(String verificationID, String otpCode) async {
    return '';
  }

  void signOut() {}
}
