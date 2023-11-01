import 'package:flutter/material.dart';
import 'package:serenity/editor/components/check_list_item.dart';
import 'package:serenity/editor/components/task_list_item.dart';
import 'package:serenity/editor/components/unorderd_list_item.dart';
import 'package:serenity/editor/styles/stylesheet.dart';
import 'package:serenity/states/inherited/markdown_document_inherited.dart';
import 'package:serenity/states/notifiers/caret_blink_mode_notifier.dart';
import 'package:super_editor/super_editor.dart';

import '../styles/apple_dark.dart';

class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({required super.key});

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  @override
  Widget build(BuildContext context) {
    final document = MarkdownDocument.of(context);
    return ValueListenableBuilder(
        valueListenable: CaretBlinkModeNotifier(),
        builder: (_, mode, __) {
          return SuperEditor(
            key: widget.key,
            editor: document.editor,
            document: MarkdownDocument.of(context).document,
            composer: document.composer,
            selectionStyle:
                const SelectionStyles(selectionColor: Color(0xFF523D2E)),
            stylesheet: buildStylesheet(defaultStylesheet).copyWith(
              documentPadding: EdgeInsets.zero,
            ),
            documentOverlayBuilders: [
              DefaultCaretOverlayBuilder(
                caretStyle: CaretStyle(
                  color: appleDark.editor.tintColor,
                  width: 2.6,
                ),
                blinkTimingMode: mode,
              ),
            ],
            componentBuilders: [
              const ParagraphComponentBuilder(),
              const ListIteComponentCustomBuilder(),
              TaskListComponentCustomBuilder(document.editor),
              CheckListComponentCustomBuilder(document.editor),
              // BlockquoteComponentBuilder(),
              // TaskComponentBuilder(_docEditor),
              // ImageComponentBuilder(),
              // HorizontalRuleComponentBuilder(),
            ],
            keyboardActions: const [
              backspaceToConvertCheckToParagraph,
              enterToInsertNewCheck,
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
