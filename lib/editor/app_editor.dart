import 'package:serenity/editor/reactions/caret_move_reaction.dart';
import 'package:super_editor/super_editor.dart';

class AppEditor {
  final MutableDocument document;
  final MutableDocumentComposer composer;

  final Editor editor;

  AppEditor({
    required this.document,
    required this.composer,
  }) : editor = Editor(
          editables: {
            Editor.documentKey: document,
            Editor.composerKey: composer,
          },
          requestHandlers: List.from(defaultRequestHandlers)..addAll([]),
          reactionPipeline: [
            CaretMoveReaction(),
          ],
        );
}
