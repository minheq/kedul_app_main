import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/widgets/field.dart';
import 'package:kedul_app_main/widgets/text.dart';
import 'package:kedul_app_main/widgets/text_input.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget {
  PhoneNumberField({Key key, this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);

    return Field(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: CountryCodePicker(
              onChanged: print,
              initialSelection: locale.countryCode,
              favorite: [locale.countryCode],
              showCountryOnly: false,
              alignLeft: true,
              textStyle: TextStyle(
                  fontSize: CustomText.getFontSize(TextSize.md),
                  color: CustomColors.textDark),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextInput(),
          ),
        ],
      ),
    );
  }
}
