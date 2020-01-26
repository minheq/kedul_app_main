enum ControlSize { sm, md, xl }

class Control {
  /// Control widgets are ones that the user interact with
  /// like pickers, inputs, buttons, checkboxes, sliders.
  /// To provide consistency among these widgets, use the Control helper

  static double toDouble(ControlSize size) {
    switch (size) {
      case ControlSize.sm:
        return 40.0;
      case ControlSize.md:
        return 48.0;
      case ControlSize.xl:
        return 56.0;
      default:
        return 48.0;
    }
  }
}
