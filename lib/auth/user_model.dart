import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/auth/user_repository.dart';

class UserModel extends ChangeNotifier {
  User _currentUser;

  UserRepository userRepository;

  UserModel({@required this.userRepository});

  bool get isAuthenticated {
    return _currentUser != null;
  }

  Future<User> get currentUser async {
    return null;
  }
}
