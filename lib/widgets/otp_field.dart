import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class OTPField extends StatelessWidget {
  OTPField({this.initialValue, this.onChanged, this.onFieldSubmitted});

  final String initialValue;
  final void Function(String) onChanged;
  final void Function(String) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ]);
  }
}
