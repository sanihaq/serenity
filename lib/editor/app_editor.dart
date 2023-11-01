import 'package:serenity/editor/components/check_list_item.dart';
import 'package:serenity/editor/components/task_list_item.dart';
import 'package:serenity/editor/components/unorderd_list_item.dart';
import 'package:super_editor/super_editor.dart';

class AppEditor {
  final MutableDocument document;
  final MutableDocumentComposer composer;

  final Editor editor;

  AppEditor({
    required this.document,
    required this.composer,
  }) : editor = Editor(
          // cSpell:ignore editables
          editables: {
            Editor.documentKey: document,
            Editor.composerKey: composer,
          },
          requestHandlers: List.from(defaultRequestHandlers)
            ..addAll([
              (request) => request is ChangeCheckCompletionRequest
                  ? ChangeCheckCompletionCommand(
                      nodeId: request.nodeId,
                      isComplete: request.isComplete,
                    )
                  : null,
              (request) => request is DeleteUpstreamAtBeginningOfNodeRequest &&
                      request.node is CheckNode
                  ? ConvertCheckToParagraphCommand(
                      nodeId: request.node.id,
                      paragraphMetadata: request.node.metadata)
                  : null,
              (request) => request is SplitExistingCheckRequest
                  ? SplitExistingCheckCommand(
                      nodeId: request.existingNodeId,
                      splitOffset: request.splitOffset,
                      newNodeId: request.newNodeId,
                    )
                  : null,
            ]),
          reactionPipeline: [
            UpdateComposerTextStylesReaction(),
            const LinkifyReaction(),

            //---- Start Content Conversions ----
            // HeaderConversionReaction(),
            const CheckListItemConversion(),
            const TaskListItemConversion(),
            const UnorderedListItemCustomConversion(),
            // const OrderedListItemConversionReaction(),
            // const BlockquoteConversionReaction(),
            // const HorizontalRuleConversionReaction(),
            // const ImageUrlConversionReaction(),
            //---- End Content Conversions ---
          ],
        );
}
