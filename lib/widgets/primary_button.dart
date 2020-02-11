import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/touchable_container.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    Key key,
    this.onPressed,
    this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Theme.of(context).buttonTheme.height,
        child: TouchableContainer(
            child: RaisedButton(
          onPressed: onPressed,
          child: Text(title),
          padding: Theme.of(context).buttonTheme.padding,
        )));
  }
}
