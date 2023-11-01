import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenity/styles/apple_dark.dart';
import 'package:super_editor/super_editor.dart';

class CheckComponent extends StatefulWidget {
  const CheckComponent({
    Key? key,
    required this.viewModel,
    this.showDebugPaint = false,
  }) : super(key: key);

  final CheckComponentViewModel viewModel;
  final bool showDebugPaint;

  @override
  State<CheckComponent> createState() => _CheckComponentState();
}

class _CheckComponentState extends State<CheckComponent>
    with ProxyDocumentComponent<CheckComponent>, ProxyTextComposable {
  final _textKey = GlobalKey();

  @override
  GlobalKey<State<StatefulWidget>> get childDocumentComponentKey => _textKey;

  @override
  TextComposable get childTextComposable =>
      childDocumentComponentKey.currentState as TextComposable;

  /// Computes the [TextStyle] for this task's inner [TextComponent].
  TextStyle _computeStyles(Set<Attribution> attributions) {
    // Show a strikethrough across the entire task if it's complete.
    final style = widget.viewModel
        .textStyleBuilder(attributions)
        .copyWith(color: appleDark.editor.textColor);
    return widget.viewModel.isComplete
        ? style.copyWith(
            decoration: style.decoration == null
                ? TextDecoration.lineThrough
                : TextDecoration.combine(
                    [TextDecoration.lineThrough, style.decoration!]),
          )
        : style;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 4),
          child: Checkbox(
            value: widget.viewModel.isComplete,
            onChanged: (newValue) {
              widget.viewModel.setComplete(newValue!);
            },
            side: MaterialStateBorderSide.resolveWith(
              (states) =>
                  BorderSide(width: 2.0, color: appleDark.editor.tintColor),
            ),
          ),
        ),
        Expanded(
          child: TextComponent(
            key: _textKey,
            text: widget.viewModel.text,
            textStyleBuilder: _computeStyles,
            textSelection: widget.viewModel.selection,
            selectionColor: widget.viewModel.selectionColor,
            highlightWhenEmpty: widget.viewModel.highlightWhenEmpty,
            showDebugPaint: widget.showDebugPaint,
          ),
        ),
      ],
    );
  }
}

class CheckNode extends TextNode {
  CheckNode({
    required String id,
    required AttributedText text,
    Map<String, dynamic>? metadata,
    required bool isComplete,
  })  : _isComplete = isComplete,
        super(id: id, text: text, metadata: metadata) {
    // Set a block type so that CheckNode's can be styled by
    // StyleRule's.
    putMetadataValue("blockType", const NamedAttribution("check"));
  }

  /// Whether this check is complete.
  bool get isComplete => _isComplete;
  bool _isComplete;
  set isComplete(bool newValue) {
    if (newValue == _isComplete) {
      return;
    }

    _isComplete = newValue;
    notifyListeners();
  }

  @override
  bool hasEquivalentContent(DocumentNode other) {
    return other is CheckNode &&
        isComplete == other.isComplete &&
        text == other.text;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CheckNode &&
          runtimeType == other.runtimeType &&
          isComplete == other.isComplete;

  @override
  int get hashCode => super.hashCode ^ isComplete.hashCode;
}

class CheckListComponentCustomBuilder implements ComponentBuilder {
  CheckListComponentCustomBuilder(this._editor);

  final Editor _editor;

  @override
  CheckComponentViewModel? createViewModel(
      Document document, DocumentNode node) {
    if (node is! CheckNode) {
      return null;
    }

    return CheckComponentViewModel(
      nodeId: node.id,
      padding: EdgeInsets.zero,
      isComplete: node.isComplete,
      setComplete: (bool isComplete) {
        _editor.execute([
          ChangeCheckCompletionRequest(
            nodeId: node.id,
            isComplete: isComplete,
          ),
        ]);
      },
      text: node.text,
      textStyleBuilder: noStyleBuilder,
      selectionColor: const Color(0x00000000),
    );
  }

  @override
  Widget? createComponent(SingleColumnDocumentComponentContext componentContext,
      SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! CheckComponentViewModel) {
      return null;
    }

    return CheckComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class CheckComponentViewModel extends SingleColumnLayoutComponentViewModel
    with TextComponentViewModel {
  CheckComponentViewModel({
    required String nodeId,
    double? maxWidth,
    required EdgeInsetsGeometry padding,
    required this.isComplete,
    required this.setComplete,
    required this.text,
    required this.textStyleBuilder,
    this.textDirection = TextDirection.ltr,
    this.textAlignment = TextAlign.left,
    this.selection,
    required this.selectionColor,
    this.highlightWhenEmpty = false,
  }) : super(nodeId: nodeId, maxWidth: maxWidth, padding: padding);

  bool isComplete;
  void Function(bool) setComplete;

  @override
  AttributedText text;
  @override
  AttributionStyleBuilder textStyleBuilder;
  @override
  TextDirection textDirection;
  @override
  TextAlign textAlignment;
  @override
  TextSelection? selection;
  @override
  Color selectionColor;
  @override
  bool highlightWhenEmpty;

  @override
  CheckComponentViewModel copy() {
    return CheckComponentViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      isComplete: isComplete,
      setComplete: setComplete,
      text: text,
      textStyleBuilder: textStyleBuilder,
      textDirection: textDirection,
      selection: selection,
      selectionColor: selectionColor,
      highlightWhenEmpty: highlightWhenEmpty,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CheckComponentViewModel &&
          runtimeType == other.runtimeType &&
          isComplete == other.isComplete &&
          setComplete == other.setComplete &&
          text == other.text &&
          textDirection == other.textDirection &&
          textAlignment == other.textAlignment &&
          selection == other.selection &&
          selectionColor == other.selectionColor &&
          highlightWhenEmpty == other.highlightWhenEmpty;

  @override
  int get hashCode =>
      super.hashCode ^
      isComplete.hashCode ^
      setComplete.hashCode ^
      text.hashCode ^
      textDirection.hashCode ^
      textAlignment.hashCode ^
      selection.hashCode ^
      selectionColor.hashCode ^
      highlightWhenEmpty.hashCode;
}

class CheckListItemConversion extends ParagraphPrefixConversionReaction {
  static final _unorderedListItemPattern = RegExp(r'^\s*[+]\s+$');

  const CheckListItemConversion();

  @override
  RegExp get pattern => _unorderedListItemPattern;

  @override
  void onPrefixMatched(
    EditContext editContext,
    RequestDispatcher requestDispatcher,
    List<EditEvent> changeList,
    ParagraphNode paragraph,
    String match,
  ) {
    requestDispatcher.execute([
      ReplaceNodeRequest(
        existingNodeId: paragraph.id,
        newNode: CheckNode(
          id: paragraph.id,
          text: AttributedText(),
          isComplete: false,
        ),
      ),
      ChangeSelectionRequest(
        DocumentSelection.collapsed(
          position: DocumentPosition(
            nodeId: paragraph.id,
            nodePosition: const TextNodePosition(offset: 0),
          ),
        ),
        SelectionChangeType.placeCaret,
        SelectionReason.contentChange,
      ),
    ]);
  }
}

class ChangeCheckCompletionRequest implements EditRequest {
  ChangeCheckCompletionRequest(
      {required this.nodeId, required this.isComplete});

  final String nodeId;
  final bool isComplete;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeCheckCompletionRequest &&
          runtimeType == other.runtimeType &&
          nodeId == other.nodeId &&
          isComplete == other.isComplete;

  @override
  int get hashCode => nodeId.hashCode ^ isComplete.hashCode;
}

class ChangeCheckCompletionCommand implements EditCommand {
  ChangeCheckCompletionCommand(
      {required this.nodeId, required this.isComplete});

  final String nodeId;
  final bool isComplete;

  @override
  void execute(EditContext context, CommandExecutor executor) {
    final checkNode =
        context.find<MutableDocument>(Editor.documentKey).getNodeById(nodeId);
    if (checkNode is! CheckNode) {
      return;
    }

    checkNode.isComplete = isComplete;

    executor.logChanges([
      DocumentEdit(
        NodeChangeEvent(nodeId),
      ),
    ]);
  }
}

class ConvertCheckToParagraphCommand implements EditCommand {
  const ConvertCheckToParagraphCommand({
    required this.nodeId,
    this.paragraphMetadata,
  });

  final String nodeId;
  final Map<String, dynamic>? paragraphMetadata;

  @override
  void execute(EditContext context, CommandExecutor executor) {
    final document = context.find<MutableDocument>(Editor.documentKey);
    final node = document.getNodeById(nodeId);
    final checkNode = node as CheckNode;
    final newMetadata = Map<String, dynamic>.from(paragraphMetadata ?? {});
    newMetadata["blockType"] = paragraphAttribution;

    final newParagraphNode = ParagraphNode(
      id: checkNode.id,
      text: checkNode.text,
      metadata: newMetadata,
    );
    document.replaceNode(oldNode: checkNode, newNode: newParagraphNode);

    executor.logChanges([
      DocumentEdit(
        NodeChangeEvent(checkNode.id),
      )
    ]);
  }
}

class SplitExistingCheckRequest implements EditRequest {
  const SplitExistingCheckRequest({
    required this.existingNodeId,
    required this.splitOffset,
    this.newNodeId,
  });

  final String existingNodeId;
  final int splitOffset;
  final String? newNodeId;
}

class SplitExistingCheckCommand implements EditCommand {
  const SplitExistingCheckCommand({
    required this.nodeId,
    required this.splitOffset,
    this.newNodeId,
  });

  final String nodeId;
  final int splitOffset;
  final String? newNodeId;

  @override
  void execute(EditContext editContext, CommandExecutor executor) {
    final document = editContext.find<MutableDocument>(Editor.documentKey);
    final composer =
        editContext.find<MutableDocumentComposer>(Editor.composerKey);
    final selection = composer.selection;

    // We only care when the caret sits at the end of a CheckNode.
    if (selection == null || !selection.isCollapsed) {
      return;
    }

    // We only care about CheckNodes.
    final node = document.getNodeById(selection.extent.nodeId);
    if (node is! CheckNode) {
      return;
    }

    // Ensure the split offset is valid.
    if (splitOffset < 0 || splitOffset > node.text.text.length + 1) {
      return;
    }

    final newCheckNode = CheckNode(
      id: newNodeId ?? Editor.createNodeId(),
      text: node.text.copyText(splitOffset),
      isComplete: false,
    );

    // Remove the text after the caret from the currently selected CheckNode.
    node.text = node.text.removeRegion(
        startOffset: splitOffset, endOffset: node.text.text.length);

    // Insert a new TextNode after the currently selected CheckNode.
    document.insertNodeAfter(existingNode: node, newNode: newCheckNode);

    // Move the caret to the beginning of the new CheckNode.
    final oldSelection = composer.selection;
    final oldComposingRegion = composer.composingRegion.value;
    final newSelection = DocumentSelection.collapsed(
      position: DocumentPosition(
        nodeId: newCheckNode.id,
        nodePosition: const TextNodePosition(offset: 0),
      ),
    );

    composer.setSelectionWithReason(
        newSelection, SelectionReason.userInteraction);
    composer.setComposingRegion(null);

    executor.logChanges([
      DocumentEdit(
        NodeChangeEvent(node.id),
      ),
      DocumentEdit(
        NodeInsertedEvent(
            newCheckNode.id, document.getNodeIndexById(newCheckNode.id)),
      ),
      SelectionChangeEvent(
        oldSelection: oldSelection,
        newSelection: newSelection,
        oldComposingRegion: oldComposingRegion,
        newComposingRegion: null,
        changeType: SelectionChangeType.pushCaret,
        reason: SelectionReason.userInteraction,
      ),
    ]);
  }
}

ExecutionInstruction enterToInsertNewCheck({
  required SuperEditorContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent is! RawKeyDownEvent) {
    return ExecutionInstruction.continueExecution;
  }

  // We only care about ENTER.
  if (keyEvent.logicalKey != LogicalKeyboardKey.enter &&
      keyEvent.logicalKey != LogicalKeyboardKey.numpadEnter) {
    return ExecutionInstruction.continueExecution;
  }

  // We only care when the selection is collapsed to a caret.
  final selection = editContext.composer.selection;
  if (selection == null || !selection.isCollapsed) {
    return ExecutionInstruction.continueExecution;
  }

  final node = editContext.document.getNodeById(selection.extent.nodeId);
  if (node is! CheckNode) {
    return ExecutionInstruction.continueExecution;
  }

  final splitOffset =
      (selection.extent.nodePosition as TextNodePosition).offset;

  editContext.editor.execute([
    SplitExistingCheckRequest(
      existingNodeId: node.id,
      splitOffset: splitOffset,
    ),
  ]);

  return ExecutionInstruction.haltExecution;
}

ExecutionInstruction backspaceToConvertCheckToParagraph({
  required SuperEditorContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent is! RawKeyDownEvent) {
    return ExecutionInstruction.continueExecution;
  }

  if (keyEvent.logicalKey != LogicalKeyboardKey.backspace) {
    return ExecutionInstruction.continueExecution;
  }

  if (editContext.composer.selection == null) {
    return ExecutionInstruction.continueExecution;
  }
  if (!editContext.composer.selection!.isCollapsed) {
    return ExecutionInstruction.continueExecution;
  }

  final node = editContext.document
      .getNodeById(editContext.composer.selection!.extent.nodeId);
  if (node is! CheckNode) {
    return ExecutionInstruction.continueExecution;
  }

  if ((editContext.composer.selection!.extent.nodePosition as TextPosition)
          .offset >
      0) {
    // The selection isn't at the beginning.
    return ExecutionInstruction.continueExecution;
  }

  editContext.editor.execute([
    DeleteUpstreamAtBeginningOfNodeRequest(node),
  ]);

  return ExecutionInstruction.haltExecution;
}
