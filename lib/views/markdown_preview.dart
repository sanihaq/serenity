import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_text_layout/super_text_layout.dart';

import '../states/inherited/markdown_document_inherited_widget.dart';
import '../states/notifiers/document_change_notifier.dart';

class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ValueListenableBuilder(
            valueListenable: DocumentChangeNotifier(),
            builder: (_, changelog, __) {
              // return Text(
              //   MarkdownDocument.of(context).toMarkdown(),
              //   style: const TextStyle(
              //     color: Color(0xFFEAEAEA),
              //     height: 1.4,
              //   ),
              // );
              final controller = AttributedTextEditingController(
                text: AttributedText(MarkdownDocument.of(context).toMarkdown()),
              );
              return SuperDesktopTextField(
                textController: controller,
                maxLines: 40,
                blinkTimingMode: BlinkTimingMode.timer,
              );
            },
          ),
        ),
      ),
    );
  }
}
