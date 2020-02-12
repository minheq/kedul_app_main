import 'package:flutter/material.dart';

class FormBuilderHelpers<T> {
  FormBuilderHelpers({this.setSubmitting, this.setFormError});

  final Function(bool isSubmitting) setSubmitting;
  final Function(String error) setFormError;
}

class FormBuilder<T extends Object> extends StatefulWidget {
  final T initialValues;
  final void Function(T values, FormBuilderHelpers<T> state) onSubmit;
  final Widget Function(BuildContext context, FormBuilderState<T> state)
      builder;
  final Map<String, String> Function(T values) validate;

  FormBuilder(
      {Key key,
      this.initialValues,
      this.onSubmit,
      this.validate,
      @required this.builder})
      : assert(builder != null),
        super(key: key);

  @override
  State<FormBuilder<T>> createState() => _FormBuilderState<T>();
}

class FormBuilderState<T> {
  FormBuilderState(
      {this.handleReset,
      this.handleSubmit,
      this.isSubmitting = false,
      this.values,
      this.errors});

  /// handleSubmit should be called when the form is ready for submission
  void Function() handleSubmit;

  /// handleReset resets form values to initial values
  void Function() handleReset;
  bool isSubmitting;
  T values;

  /// Top-level error that can be whatever string you want. For example, backend errors after submitting the form.
  String error;
  Map<String, String> errors;
}

class _FormBuilderState<T> extends State<FormBuilder<T>> {
  FormBuilderState<T> _state;

  final formKey = GlobalKey<FormState>();

  void handleSetSubmitting(bool isSubmitting) {
    setState(() {
      _state.isSubmitting = isSubmitting;
    });
  }

  void handleSetFormError(String error) {
    setState(() {
      _state.error = error;
    });
  }

  void handleReset() {
    setState(() {
      _state.values = widget.initialValues;
    });
  }

  void handleSubmit() {
    if (widget.validate != null) {
      Map<String, String> errors = widget.validate(_state.values);

      if (errors.isNotEmpty) {
        setState(() {
          _state.errors = errors;
        });
        return;
      }
    }

    widget.onSubmit(
        _state.values,
        FormBuilderHelpers(
            setFormError: handleSetFormError,
            setSubmitting: handleSetSubmitting));

    setState(() {
      _state.errors = Map();
      _state.isSubmitting = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _state = FormBuilderState(
      values: widget.initialValues,
      handleSubmit: handleSubmit,
      handleReset: handleReset,
      errors: Map(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: formKey, child: widget.builder(context, _state));
  }
}
