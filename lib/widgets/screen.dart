import 'package:flutter/material.dart';

class TideScreen extends StatelessWidget {
  /// Creates a screen widget. It will add

  TideScreen({@required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: body,
        ));
  }
}
