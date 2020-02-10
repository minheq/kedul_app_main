import 'package:flutter/services.dart';
import 'package:kedul_app_main/theme.dart';
import 'package:flutter/material.dart';

Color customTextFieldCursorColor = NamedColors.textDark;
InputDecoration customTextFieldInputDecoration = InputDecoration(
  border: InputBorder.none,
);

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.key,
      this.onChanged,
      this.keyboardType,
      this.inputFormatters,
      this.controller});

  final List<TextInputFormatter> inputFormatters;
  final Key key;

  /// Type of the keyboard.
  final TextInputType keyboardType;
  final void Function(String) onChanged;

  /// TextEditingController to pass to the TextField
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      cursorColor: customTextFieldCursorColor,
      keyboardType: keyboardType,
      decoration: customTextFieldInputDecoration,
    );
  }
}
