import 'package:kedul_app_main/theme.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextInput({this.key, this.onChanged, this.keyboardType});

  final Key key;
  final TextInputType keyboardType;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String txt) {},
      cursorColor: CustomColors.textDark,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
