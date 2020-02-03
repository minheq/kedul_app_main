import 'package:flutter/services.dart';
import 'package:kedul_app_main/widgets/country_code_form_field.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/text_form_field.dart';

class PhoneNumber {
  ///
  /// PhoneNumber consists of the local phone number and its country code
  ///
  PhoneNumber({this.phoneNumber, this.countryCode});

  final String phoneNumber;
  final String countryCode;
}

class PhoneNumberFormField extends FormField<PhoneNumber> {
  PhoneNumberFormField(
      {FormFieldSetter<PhoneNumber> onSaved,
      FormFieldValidator<PhoneNumber> validator,
      PhoneNumber initialValue,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<PhoneNumber> state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: CountryCodeFormField(
                      initialValue: initialValue.countryCode,
                      onChanged: (countryCode) {
                        state.didChange(PhoneNumber(
                            phoneNumber: state.value.phoneNumber,
                            countryCode: countryCode));
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomTextFormField(
                        initialValue: initialValue.phoneNumber,
                        onChanged: (phoneNumber) {
                          state.didChange(PhoneNumber(
                              phoneNumber: phoneNumber,
                              countryCode: state.value.countryCode));
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ]),
                  ),
                ],
              );
            });
}
