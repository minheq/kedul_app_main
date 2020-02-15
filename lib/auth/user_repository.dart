import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/auth/user_entity.dart';

class UserRepository {
  APIClient _apiClient;

  UserRepository(this._apiClient);

  Future<User> loadUser() async {
    return null;
  }
}
