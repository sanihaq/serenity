import 'package:flutter/material.dart';

import '../editor/markdown_editor.dart';
import '../styles/ui_sizes.dart';

class MarkdownEditorPadded extends StatelessWidget {
  final ValueKey editorKey;

  const MarkdownEditorPadded({super.key, required this.editorKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: appTitleBarHeight,
        bottom: appStatusBarHeight,
      ),
      child: MarkdownEditor(
        key: editorKey,
      ),
    );
  }
}
