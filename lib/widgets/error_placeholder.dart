import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  ErrorPlaceholder({this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      child: Text("Something wrong happened"),
    ));
  }
}
