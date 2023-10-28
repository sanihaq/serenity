import 'package:flutter/material.dart';
import 'package:serenity/states/inherited/text_controller_inherited.dart';
import 'package:super_editor/super_editor.dart';

import '../states/notifiers/caret_blink_mode_notifier.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({required super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CaretBlinkModeNotifier(),
      builder: (_, mode, __) {
        return SuperDesktopTextField(
          textController: TextController.of(context).controller,
          maxLines: null,
          blinkTimingMode: mode,
          textStyleBuilder: (_) => const TextStyle(
            fontFamily: 'SFPro',
            fontSize: 15,
          ),
          padding: const EdgeInsets.only(top: 24.0, right: 8.0),
        );
      },
    );
  }
}
