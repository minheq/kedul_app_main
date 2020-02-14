const bool _isProduction = bool.fromEnvironment('dart.vm.product');

class AppConfig {
  final String apiBaseURL = _isProduction ? "" : "http://localhost:4000";
}

class AppEnvironment {
  final bool isProduction = _isProduction;
}
