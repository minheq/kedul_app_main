import 'package:flutter/material.dart';

class FormBuilderHelpers<T> {
  FormBuilderHelpers({this.setSubmitting, this.setFormError});

  final Function(bool isSubmitting) setSubmitting;
  final Function(String status) setFormError;
}

class FormBuilder<T extends Object> extends StatefulWidget {
  /// InitialValues are initial values for the form values
  final T initialValues;

  /// OnSubmit is a call back for handleSubmit
  final void Function(T values, FormBuilderHelpers<T> state) onSubmit;

  /// Builder to build widgets using the form state
  final Widget Function(BuildContext context, FormBuilderState<T> state)
      builder;

  /// Validate is called when submitting the form. Sets errors if it fails some validation
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

  /// isSubmitting indicates that the form is submitted and awaits some response
  bool isSubmitting;

  /// values is the stored form values
  T values;

  /// status of the form can be anything. For example, backend errors after submitting the form.
  String status;

  /// Errors is a map of fields to error strings
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

  void handleSetStatus(String status) {
    setState(() {
      _state.status = status;
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
            setFormError: handleSetStatus, setSubmitting: handleSetSubmitting));

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
