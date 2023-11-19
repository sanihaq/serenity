import 'dart:ui';

import 'package:super_editor/super_editor.dart';

Set<Attribution> getAllAttributions(
  EditContext editContext,
  TextNode node,
) {
  final composer =
      editContext.find<MutableDocumentComposer>(Editor.composerKey);

  final textPosition = composer.selection!.extent.nodePosition as TextPosition;

  if (textPosition.offset == 0 && node.text.text.isEmpty) {
    return {};
  }

  return node.text.getAllAttributionsAt(textPosition.offset);
}
