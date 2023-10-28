import 'package:flutter/material.dart';
import 'package:serenity/editor/text_editor.dart';
import 'package:serenity/states/inherited/text_controller_inherited.dart';
import 'package:serenity/styles/ui_sizes.dart';

import '../states/inherited/markdown_document_inherited.dart';
import '../states/notifiers/document_change_notifier.dart';

class MarkdownPreview extends StatelessWidget {
  final ValueKey editorKey;
  const MarkdownPreview({
    super.key,
    required this.editorKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: appTitleBarHeight,
          bottom: appStatusBarHeight,
        ),
        child: ValueListenableBuilder(
          valueListenable: DocumentChangeNotifier(),
          builder: (_, changelog, __) {
            return TextController(
              text: MarkdownDocument.of(context).toMarkdown(),
              child: TextEditor(
                key: editorKey,
              ),
            );
          },
        ),
      ),
    );
  }
}
