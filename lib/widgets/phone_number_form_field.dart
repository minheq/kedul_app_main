import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class PhoneNumber {
  PhoneNumber({@required this.phoneNumber, @required this.countryCode});

  String phoneNumber;
  String countryCode;
}

class PhoneNumberFormField extends FormField<PhoneNumber> {
  PhoneNumberFormField({
    FormFieldSetter<PhoneNumber> onSaved,
    FormFieldValidator<PhoneNumber> validator,
    PhoneNumber initialValue,
    ValueChanged<PhoneNumber> onChanged,
    void Function(PhoneNumber) onFieldSubmitted,
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
                    flex: 5,
                    child: CountryCodePicker(
                        onChanged: (countryCode) {
                          if (onChanged != null) {
                            onChanged(PhoneNumber(
                                phoneNumber: state.value.phoneNumber,
                                countryCode: countryCode.code));
                          }

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
                      flex: 13,
                      child: TextFormField(
                          initialValue: initialValue.phoneNumber,
                          onChanged: (phoneNumber) {
                            if (onChanged != null) {
                              onChanged(PhoneNumber(
                                  phoneNumber: phoneNumber,
                                  countryCode: state.value.countryCode));
                            }
                            state.didChange(PhoneNumber(
                                phoneNumber: phoneNumber,
                                countryCode: state.value.countryCode));
                          },
                          cursorColor: Theme.of(state.context).cursorColor,
                          onFieldSubmitted: (phoneNumber) {
                            onFieldSubmitted(PhoneNumber(
                                phoneNumber: state.value.phoneNumber,
                                countryCode: state.value.countryCode));
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ])),
                ],
              );
            });
}
