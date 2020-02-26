import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kedul_app_main/analytics/analytics_model.dart';

import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';

class Business {
  final String id;
  final String userID;
  final String name;
  final String profileImageID;
  final String createdAt;
  final String updatedAt;

  Business(
      {this.id,
      this.userID,
      this.name,
      this.profileImageID,
      this.createdAt,
      this.updatedAt});

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      userID: json['user_id'],
      name: json['name'],
      profileImageID: json['profile_image_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class BusinessModel extends ChangeNotifier {
  Map<String, Business> _cache;

  final APIClient _apiClient;
  final AnalyticsModel _analyticsModel;

  BusinessModel(this._apiClient, this._analyticsModel);

  Future<Business> getBusinessByID(String businessID,
      {bool forceFetch = false}) async {
    const op = "getBusinessByID";
    Business cachedBusiness = _cache["${op}_$businessID"];

    if (!forceFetch && cachedBusiness != null) {
      return cachedBusiness;
    }

    http.Response response = await _apiClient.get('/businesses/$businessID');

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    Business business = Business.fromJson(json.decode(response.body));

    _cache["${op}_${business.id}"] = business;

    return business;
  }

  Future<List<Business>> getBusinessesByUserID(String userID,
      {bool forceFetch = false}) async {
    const op = "getBusinessesByUserID";
    // List<Business> cachedBusinesses = _cache["${op}_$userID"];
    http.Response response = await _apiClient.get('/users/$userID/businesses');

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    Map<String, dynamic> businessConnection = json.decode(response.body);

    Iterable data = businessConnection['data'];

    List<Business> businesses = [];

    for (Map json in data) {
      businesses.add(Business.fromJson(json));
    }

    return businesses;
  }

  Future<Business> createBusiness(String name) async {
    String body = _CreateBusinessInputBody(name: name).toJson();

    http.Response response = await _apiClient.post('/businesses', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    Business data = Business.fromJson(json.decode(response.body));

    return data;
  }
}

class _CreateBusinessInputBody {
  _CreateBusinessInputBody({this.name});

  String name;

  String toJson() {
    Map mapData = Map();

    mapData['name'] = name;

    String body = json.encode(mapData);

    return body;
  }
}
