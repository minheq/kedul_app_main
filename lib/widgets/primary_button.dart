import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/touchable_container.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    this.onPressed,
    this.title,
    this.isSubmitting = false,
  });

  final VoidCallback onPressed;
  final bool isSubmitting;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Theme.of(context).buttonTheme.height,
        child: TouchableContainer(
            child: RaisedButton(
          onPressed: isSubmitting ? null : onPressed,
          child: Text(
            isSubmitting ? "Submitting" : title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: Theme.of(context).buttonTheme.padding,
        )));
  }
}
