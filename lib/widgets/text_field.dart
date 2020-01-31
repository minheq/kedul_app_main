import 'package:kedul_app_main/widgets/field.dart';
import 'package:kedul_app_main/widgets/text_input.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  TextInputField(
      {this.key,
      this.errorText,
      this.labelText,
      this.onChanged,
      this.keyboardType});

  final Key key;
  final String errorText;
  final String labelText;
  final TextInputType keyboardType;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Field(
      labelText: labelText,
      errorText: errorText,
      child: TextInput(),
    );
  }
}
