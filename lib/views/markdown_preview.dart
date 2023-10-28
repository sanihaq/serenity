import 'package:flutter/material.dart';
import 'package:serenity/states/inherited/markdown_document_inherited_widget.dart';

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
            builder: (_, changelog, __) => Text(
              MarkdownDocument.of(context).toMarkdown(),
              style: const TextStyle(
                color: Color(0xFFEAEAEA),
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
