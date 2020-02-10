import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme.dart';

class ScreenContainer extends StatelessWidget {
  /// Creates a screen widget. It will add

  ScreenContainer(
      {@required this.body, this.topBar, this.persistentFooterButtons});

  final Widget body;
  final PreferredSizeWidget topBar;
  final List<Widget> persistentFooterButtons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NamedColors.white,
        appBar: topBar,
        body: body,
        persistentFooterButtons: persistentFooterButtons);
  }
}
