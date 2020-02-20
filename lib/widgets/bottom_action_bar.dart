import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';

class BottomActionBar extends StatelessWidget {
  BottomActionBar({@required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BodyPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
    ));
  }
}
