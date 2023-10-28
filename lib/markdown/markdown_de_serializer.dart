import 'dart:convert';

import 'package:markdown/markdown.dart' as md;
import 'package:super_editor/super_editor.dart';

import 'markdown_node_visitor.dart';

MutableDocument markdownToDocument(String markdown) {
  final markdownLines = const LineSplitter().convert(markdown);

  // for (var line in markdownLines) {
  //   print(line);
  // }

  final markdownDoc = md.Document(
    blockSyntaxes: [],
  );

  final blockParser = md.BlockParser(markdownLines, markdownDoc);

  final markdownNodes = blockParser.parseLines();

  final nodeVisitor = MarkdownToDocument();

  for (final node in markdownNodes) {
    node.accept(nodeVisitor);
  }

  final documentNodes = nodeVisitor.content;

  if (documentNodes.isEmpty) {
    // An empty markdown was parsed.
    // For the user to be able to interact with the editor, at least one
    // node is required, so we add an empty paragraph.
    documentNodes.add(
      ParagraphNode(id: Editor.createNodeId(), text: AttributedText()),
    );
  }

  return MutableDocument(nodes: documentNodes);
}
