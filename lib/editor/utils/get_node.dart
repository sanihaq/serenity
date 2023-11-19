import 'package:super_editor/super_editor.dart';

T? getNodeAtPositionOfType<T extends DocumentNode>(
  EditContext editContext, [
  DocumentPosition? previousSelectionExtent,
]) {
  final document = editContext.find<MutableDocument>(Editor.documentKey);
  final composer =
      editContext.find<MutableDocumentComposer>(Editor.composerKey);

  if (composer.selection?.extent == previousSelectionExtent) {
    return null;
  }

  final selectionExtent = composer.selection?.extent;
  if (selectionExtent != null &&
      selectionExtent.nodePosition is TextNodePosition &&
      previousSelectionExtent != null &&
      previousSelectionExtent.nodePosition is TextNodePosition) {
    // The current and previous selections are text positions. Check for the situation where the two
    // selections are functionally equivalent, but the affinity changed.
    final selectedNodePosition =
        selectionExtent.nodePosition as TextNodePosition;
    final previousSelectedNodePosition =
        previousSelectionExtent.nodePosition as TextNodePosition;

    if (selectionExtent.nodeId == previousSelectionExtent.nodeId &&
        selectedNodePosition.offset == previousSelectedNodePosition.offset) {
      // The text selection changed, but only the affinity is different. An affinity change doesn't alter
      // the selection from the user's perspective, so don't alter any preferences. Return.
      return null;
    }
  }

  previousSelectionExtent = composer.selection?.extent;

  if (composer.selection == null || !composer.selection!.isCollapsed) {
    return null;
  }

  final node = document.getNodeById(composer.selection!.extent.nodeId);
  if (node is T) {
    return node;
  }
  return null;
}
