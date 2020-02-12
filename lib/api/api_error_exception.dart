class APIErrorException implements Exception {
  String message;
  String code;
  String docURL;

  APIErrorException({this.message, this.code, this.docURL});
}
