import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class OTPFormField extends FormField<String> {
  OTPFormField({
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    String initialValue,
    ValueChanged<String> onChanged,
    void Function(String) onFieldSubmitted,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<String> state) {
              return TextFormField(
                  onChanged: (otp) {
                    state.didChange(otp);
                  },
                  onFieldSubmitted: onFieldSubmitted,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ]);
            });
}
