import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_model.dart';
import 'package:kedul_app_main/auth/user_repository.dart';
import 'package:kedul_app_main/theme.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

APIClient apiClient = APIClient();

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<ThemeModel>(
    create: (context) {
      return ThemeModel();
    },
  ),
  ChangeNotifierProvider<UserModel>(
    create: (context) {
      return UserModel(userRepository: UserRepository(apiClient: apiClient));
    },
  ),
  ChangeNotifierProxyProvider<UserModel, AuthModel>(
    create: (context) {
      return AuthModel(apiClient: apiClient);
    },
    update: (context, userModel, authModel) {
      authModel.setUserModel(userModel);

      return authModel;
    },
  )
];
