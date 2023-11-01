import 'package:flutter/widgets.dart';
import 'package:serenity/editor/app_editor.dart';
import 'package:serenity/markdown/markdown_serializer.dart';
import 'package:serenity/utils/exceptions/not_found_exception.dart';
import 'package:super_editor/super_editor.dart';

import '../notifiers/document_change_notifier.dart';

class MarkdownDocument extends InheritedWidget {
  final MutableDocument document;
  final MutableDocumentComposer composer;
  late final Editor editor;

  MarkdownDocument({super.key, required super.child, required this.document})
      : composer = MutableDocumentComposer() {
    editor = AppEditor(document: document, composer: composer).editor;
    document.addListener((changelog) {
      DocumentChangeNotifier().change(changelog);
    });
  }
  String toMarkdown() {
    return documentToMarkdown(document);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MarkdownDocument of(BuildContext context) {
    final doc = context.dependOnInheritedWidgetOfExactType<MarkdownDocument>();
    if (doc == null) {
      throw NotFoundException(
          'No parent `MarkdownDocument` found in tree stack.');
    }

    return doc;
  }
}
