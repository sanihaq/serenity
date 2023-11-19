import 'package:flutter/material.dart';
import 'package:serenity/states/inherited/text_controller_inherited.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_text_layout/super_text_layout.dart';

import '../styles/apple_dark.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({required super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return SuperDesktopTextField(
      textController: TextController.of(context).controller,
      maxLines: null,
      caretStyle: CaretStyle(
        color: appleDark.editor.tintColor,
        width: 2.2,
      ),
      selectionHighlightStyle:
          const SelectionHighlightStyle(color: Color(0xFF523D2E)),
      textStyleBuilder: (_) => const TextStyle(
        fontFamily: 'SFPro',
        fontSize: 15,
      ),
      padding: const EdgeInsets.only(top: 24.0, right: 8.0),
    );
  }
}
