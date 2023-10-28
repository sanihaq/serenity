import 'package:flutter/cupertino.dart';
import 'package:super_text_layout/super_text_layout.dart';

class CaretBlinkModeNotifier extends ValueNotifier<BlinkTimingMode> {
  static final CaretBlinkModeNotifier _shared = CaretBlinkModeNotifier._sharedInstance();
  factory CaretBlinkModeNotifier() => _shared;
  CaretBlinkModeNotifier._sharedInstance() : super(BlinkTimingMode.timer);

  void setValue(BlinkTimingMode mode) {
    value = mode;
  }
}
