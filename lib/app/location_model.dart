import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/api/http_response_utils.dart';
import 'package:kedul_app_main/storage/storage_model.dart';

class Location {
  final String id;
  final String businessID;
  final String name;
  final String profileImageID;
  final String createdAt;
  final String updatedAt;

  Location(
      {this.id,
      this.businessID,
      this.name,
      this.profileImageID,
      this.createdAt,
      this.updatedAt});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      businessID: json['business_id'],
      name: json['name'],
      profileImageID: json['profile_image_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class LocationModel extends ChangeNotifier {
  Location _currentLocation;
  final APIClient _apiClient;
  final StorageModel _storageModel;
  final AnalyticsModel _analyticsModel;

  LocationModel(this._apiClient, this._storageModel, this._analyticsModel);

  Location get currentLocation {
    return _currentLocation;
  }

  Future<Location> getCurrentLocation() async {
    String locationID;

    try {
      locationID = await _storageModel.read("location_id");

      if (locationID == null) {
        return null;
      }
    } catch (e, s) {
      _analyticsModel.recordError(e, s);
      return null;
    }

    try {
      http.Response response = await _apiClient.get('/locations/$locationID');

      if (HTTPResponseUtils.isErrorResponse(response)) {
        ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

        throw APIErrorException(message: data.message);
      }

      Location location = Location.fromJson(json.decode(response.body));

      return location;
    } catch (e, s) {
      _analyticsModel.recordError(e, s);

      return null;
    }
  }

  Future<Location> createLocation(String name) async {
    String body = _CreateLocationInputBody(name: name).toJson();

    http.Response response = await _apiClient.post('/locations', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    Location data = Location.fromJson(json.decode(response.body));

    return data;
  }
}

class _CreateLocationInputBody {
  _CreateLocationInputBody({this.name});

  String name;

  String toJson() {
    Map mapData = Map();

    mapData['name'] = name;

    String body = json.encode(mapData);

    return body;
  }
}
