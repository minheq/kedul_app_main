import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/touchable_container.dart';
import 'package:provider/provider.dart';

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
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return SizedBox(
        height: theme.utilityStyles.controlHeight,
        child: TouchableContainer(
            child: RaisedButton(
          onPressed: isSubmitting ? null : onPressed,
          child: Text(
            isSubmitting ? "Submitting" : title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colors.textButtonPrimary),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        )));
  }
}
