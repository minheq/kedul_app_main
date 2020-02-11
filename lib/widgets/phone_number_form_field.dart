import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/data/phone_number.dart';

class PhoneNumberFormField extends FormField<PhoneNumber> {
  PhoneNumberFormField({
    FormFieldSetter<PhoneNumber> onSaved,
    FormFieldValidator<PhoneNumber> validator,
    PhoneNumber initialValue,
    void Function(String) onFieldSubmitted,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<PhoneNumber> state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: CountryCodePicker(
                        onChanged: (countryCode) {
                          state.didChange(PhoneNumber(
                              phoneNumber: state.value.phoneNumber,
                              countryCode: countryCode.code));
                        },
                        padding: EdgeInsets.only(left: 8.0),
                        initialSelection: 'VN',
                        favorite: ['VN'],
                        showCountryOnly: false,
                        alignLeft: true),
                  ),
                  SizedBox(
                      height: 32,
                      child: VerticalDivider(
                        color: Colors.black45,
                        width: 1,
                      )),
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                          initialValue: initialValue.phoneNumber,
                          onChanged: (phoneNumber) {
                            state.didChange(PhoneNumber(
                                phoneNumber: phoneNumber,
                                countryCode: state.value.countryCode));
                          },
                          onFieldSubmitted: onFieldSubmitted,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ])),
                ],
              );
            });
}
