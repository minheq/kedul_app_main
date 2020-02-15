import 'package:flutter/material.dart';

class BodyPadding extends StatelessWidget {
  BodyPadding({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: child,
    );
  }
}
