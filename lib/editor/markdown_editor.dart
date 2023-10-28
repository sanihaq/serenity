import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serenity/editor/styles/stylesheet.dart';
import 'package:serenity/states/inherited/markdown_document_inherited_widget.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_text_layout/super_text_layout.dart';

import '../themes/apple_dark.dart';
import 'components/list_item.dart';

class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({required super.key});

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  @override
  Widget build(BuildContext context) {
    final document = MarkdownDocument.of(context);
    return SuperEditor(
      key: widget.key,
      editor: document.editor,
      document: MarkdownDocument.of(context).document,
      composer: document.composer,
      selectionStyle: const SelectionStyles(selectionColor: Color(0xFF523D2E)),
      stylesheet: buildStylesheet(defaultStylesheet).copyWith(
        documentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      ),
      documentOverlayBuilders: [
        DefaultCaretOverlayBuilder(
          caretStyle: CaretStyle(
            color: appleDark.editor.tintColor,
            width: 2.6,
          ),
          blinkTimingMode: BlinkTimingMode.timer,
        ),
      ],
      imeOverrides: null,
      componentBuilders: const [
        ParagraphComponentBuilder(),
        ListItemCustomComponentBuilder(),
        // BlockquoteComponentBuilder(),
        // TaskComponentBuilder(_docEditor),
        // ImageComponentBuilder(),
        // HorizontalRuleComponentBuilder(),
      ],
    );
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
