import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:provider/provider.dart';

class PhoneNumberField extends StatelessWidget {
  PhoneNumberField(
      {this.initialPhoneNumber,
      this.initialCountryCode = 'VN',
      this.onPhoneNumberChanged,
      this.onCountryCodeChanged,
      this.onFieldSubmitted});

  final String initialPhoneNumber;
  final String initialCountryCode;
  final void Function(String phoneNumber) onPhoneNumberChanged;
  final void Function(String countryCode) onCountryCodeChanged;
  final void Function(String phoneNumber) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 5,
          child: CountryCodePicker(
              onChanged: (countryCode) {
                if (onCountryCodeChanged != null) {
                  onCountryCodeChanged(countryCode.code);
                }
              },
              padding: EdgeInsets.only(left: 8.0),
              initialSelection: initialCountryCode,
              favorite: [initialCountryCode],
              showCountryOnly: false,
              alignLeft: true),
        ),
        SizedBox(
            height: 32,
            child: VerticalDivider(
              color: theme.colors.border,
              width: 1,
            )),
        Expanded(
            flex: 13,
            child: TextFormField(
                initialValue: initialPhoneNumber,
                onChanged: (phoneNumber) {
                  if (onPhoneNumberChanged != null) {
                    onPhoneNumberChanged(phoneNumber);
                  }
                },
                onFieldSubmitted: (phoneNumber) {
                  onFieldSubmitted(phoneNumber);
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly])),
      ],
    );
  }
}
