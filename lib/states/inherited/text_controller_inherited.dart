import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../../utils/exceptions/not_found_exception.dart';

class TextController extends InheritedWidget {
  final AttributedTextEditingController controller;

  TextController({super.key, required super.child, required String text})
      : controller = AttributedTextEditingController(text: AttributedText(text));

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static TextController of(BuildContext context) {
    final controller = context.dependOnInheritedWidgetOfExactType<TextController>();
    if (controller == null) {
      throw NotFoundException('No parent `TextController` found in tree stack.');
    }

    return controller;
  }
}
