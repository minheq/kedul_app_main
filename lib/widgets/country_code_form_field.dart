import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class CountryCodeFormField extends FormField<String> {
  CountryCodeFormField(
      {FormFieldSetter<String> onSaved,
      FormFieldValidator<String> validator,
      String initialValue = 'VN',
      List<String> favorite = const ['VN'],
      ValueChanged<String> onChanged,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<String> state) {
              return FormFieldContainer(
                  child: CountryCodePicker(
                onChanged: (countryCode) {
                  if (onChanged != null) {
                    onChanged(countryCode.code);
                  }
                  state.didChange(countryCode.code);
                },
                initialSelection: 'VN',
                favorite: favorite,
                showCountryOnly: false,
                alignLeft: true,
                textStyle: TextStyle(
                    fontSize: getFontSize(TextSize.md),
                    color: NamedColors.textDark),
              ));
            });
}
