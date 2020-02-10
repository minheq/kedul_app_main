import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  APIClient apiClient;

  UserRepository({@required this.apiClient});

  Future<User> loadUser() async {
    return null;
  }
}
