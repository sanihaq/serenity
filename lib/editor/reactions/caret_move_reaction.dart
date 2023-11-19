import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:serenity/editor/utils/get_attributions.dart';
import 'package:serenity/editor/utils/get_node.dart';
import 'package:serenity/editor/utils/get_tag_text.dart';
import 'package:super_editor/super_editor.dart';

class CaretMoveReaction implements EditReaction {
  DocumentPosition? _previousSelectionExtent;

  @override
  void react(EditContext editorContext, RequestDispatcher requestDispatcher,
      List<EditEvent> changeList) {
    final lastSelectionChange =
        changeList.lastWhereOrNull((element) => element is SelectionChangeEvent)
            as SelectionChangeEvent?;
    if (lastSelectionChange == null) {
      // The selection didn't change in this transaction.
      return;
    }
    Attribution? attr;
    SpanRange? range;
    switch (lastSelectionChange.changeType) {
      case SelectionChangeType.placeCaret:
      case SelectionChangeType.pushCaret:
      case SelectionChangeType.collapseSelection:
        (range, attr) = _getAttrRange(editorContext);
      case SelectionChangeType.expandSelection:
      case SelectionChangeType.pushExtent:
        print('remove on caret move');
      default:
    }
    final node = getNodeAtPositionOfType<TextNode>(
        editorContext, _previousSelectionExtent);
    if (range != null && node != null && attr != null) {
      final tag = tagTextFromAttr(attr);
      if (tag.isEmpty) return;
      final text = node.text.copyText(range.start, range.end + 1).text;
      final start = text.startsWith(tag);
      final end = text.endsWith(tag);
      requestDispatcher.execute([
        if (!end)
          InsertTextRequest(
            documentPosition: DocumentPosition(
                nodeId: node.id,
                nodePosition: TextNodePosition(offset: range.end + 1)),
            textToInsert: tag,
            attributions: {attr},
          ),
        if (!start)
          InsertTextRequest(
            documentPosition: DocumentPosition(
                nodeId: node.id,
                nodePosition: TextNodePosition(offset: range.start)),
            textToInsert: tag,
            attributions: {attr},
          ),
      ]);
    }
  }

  (SpanRange?, Attribution?) _getAttrRange(EditContext editContext) {
    var emptyResult = (null, null);
    final composer =
        editContext.find<MutableDocumentComposer>(Editor.composerKey);

    final node = getNodeAtPositionOfType<TextNode>(
        editContext, _previousSelectionExtent);

    if (node == null) return emptyResult;

    Set<Attribution> allAttributions = getAllAttributions(editContext, node);

    if (allAttributions.isEmpty) return emptyResult;

    final textPosition =
        composer.selection!.extent.nodePosition as TextPosition;

    SpanRange? range;
    Attribution? attr;
    if (allAttributions.contains(boldAttribution) &&
        allAttributions.contains(italicsAttribution)) {
      // '***';
      range =
          node.text.getAttributedRange({boldAttribution}, textPosition.offset);
    } else if (allAttributions.contains(boldAttribution)) {
      //  '**';
      attr = boldAttribution;
      range =
          node.text.getAttributedRange({boldAttribution}, textPosition.offset);
    } else if (allAttributions.contains(italicsAttribution)) {
      //  '*';
      attr = italicsAttribution;
      range = node.text
          .getAttributedRange({italicsAttribution}, textPosition.offset);
    }
    if (range != null) {
      return (range, attr);
    }
    return emptyResult;
  }
}
