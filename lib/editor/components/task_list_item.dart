import 'package:flutter/material.dart';
import 'package:serenity/styles/apple_dark.dart';
import 'package:super_editor/super_editor.dart';

class TaskCustomComponent extends StatefulWidget {
  const TaskCustomComponent({
    Key? key,
    required this.viewModel,
    this.showDebugPaint = false,
  }) : super(key: key);

  final TaskComponentViewModel viewModel;
  final bool showDebugPaint;

  @override
  State<TaskCustomComponent> createState() => _TaskCustomComponentState();
}

class _TaskCustomComponentState extends State<TaskCustomComponent>
    with ProxyDocumentComponent<TaskCustomComponent>, ProxyTextComposable {
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
            shape: const CircleBorder(),
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

class TaskListComponentCustomBuilder implements ComponentBuilder {
  TaskListComponentCustomBuilder(this._editor);

  final Editor _editor;

  @override
  TaskComponentViewModel? createViewModel(
      Document document, DocumentNode node) {
    if (node is! TaskNode) {
      return null;
    }

    return TaskComponentViewModel(
      nodeId: node.id,
      padding: EdgeInsets.zero,
      isComplete: node.isComplete,
      setComplete: (bool isComplete) {
        _editor.execute([
          ChangeTaskCompletionRequest(
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
    if (componentViewModel is! TaskComponentViewModel) {
      return null;
    }

    return TaskCustomComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class TaskListItemConversion extends ParagraphPrefixConversionReaction {
  static final _unorderedListItemPattern = RegExp(r'^\s*[*]\s+$');

  const TaskListItemConversion();

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
        newNode: TaskNode(
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
