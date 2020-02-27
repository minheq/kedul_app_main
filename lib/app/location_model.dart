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
  Map<String, Location> _cache = Map();
  Location _currentLocation;
  final APIClient _apiClient;
  final StorageModel _storageModel;
  final AnalyticsModel _analyticsModel;

  LocationModel(this._apiClient, this._storageModel, this._analyticsModel);

  Location get currentLocation {
    return _currentLocation;
  }

  Future<void> setCurrentLocation(Location location) async {
    _currentLocation = location;

    await _storageModel.write("location_id", location.id);

    notifyListeners();
  }

  Future<Location> getLocationByID(String locationID,
      {bool forceFetch = false}) async {
    Location cachedLocation = _cache[locationID];

    if (!forceFetch && cachedLocation != null) {
      return cachedLocation;
    }

    http.Response response = await _apiClient.get('/locations/$locationID');

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    Location location = Location.fromJson(json.decode(response.body));

    _cache[location.id] = location;

    return location;
  }

  Future<Location> getCurrentLocation() async {
    if (_currentLocation != null) {
      return _currentLocation;
    }

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
      // Clear saved location_id since it is causing trouble
      await _storageModel.remove("location_id");
      _analyticsModel.recordError(e, s);

      return null;
    }
  }

  Future<Location> createLocation(String name, String businessID) async {
    String body =
        _CreateLocationInputBody(name: name, businessID: businessID).toJson();

    http.Response response = await _apiClient.post('/locations', body);

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    Location location = Location.fromJson(json.decode(response.body));

    _cache[location.id] = location;

    return location;
  }

  Future<List<Location>> getLocationsByUserIDAndBusinessID(
      String userID, String businessID,
      {bool forceFetch = false}) async {
    http.Response response =
        await _apiClient.get('/users/$userID/businesses/$businessID/locations');

    if (HTTPResponseUtils.isErrorResponse(response)) {
      ErrorResponse data = ErrorResponse.fromJson(json.decode(response.body));

      throw APIErrorException(message: data.message);
    }

    Map<String, dynamic> locationConnection = json.decode(response.body);

    Iterable data = locationConnection['data'];

    List<Location> locations = [];

    for (Map json in data) {
      Location location = Location.fromJson(json);

      locations.add(location);
    }

    return locations;
  }
}

class _CreateLocationInputBody {
  _CreateLocationInputBody({this.name, this.businessID});

  String name;
  String businessID;

  String toJson() {
    Map mapData = Map();

    mapData['name'] = name;
    mapData['business_id'] = businessID;

    String body = json.encode(mapData);

    return body;
  }
}
