import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/text.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    return SafeArea(
        child: Row(
      children: [
        if (canPop) BackButton(),
        if (title != null) CustomText(title),
      ],
    ));
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
