import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serenity/markdown/markdown_de_serializer.dart';
import 'package:serenity/states/inherited/markdown_document_inherited.dart';
import 'package:serenity/views/markdown_editor_padded.dart';

import '../views/components/title_bar.dart';
import '../views/markdown_preview.dart';

class MarkdownTestScene extends StatefulWidget {
  const MarkdownTestScene({super.key});

  @override
  State<MarkdownTestScene> createState() => _MarkdownTestSceneState();
}

class _MarkdownTestSceneState extends State<MarkdownTestScene> {
  final text = """
This is a **daily note** you are reading right now - today's note to be exact. **Here you start your day**. You have one individual note for every day in your calendar.

→ *What goes in here?* Anything you have on your mind for that day:
""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MarkdownDocument(
            document: markdownToDocument(text),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: MarkdownEditorPadded(
                    editorKey: ValueKey('App-Markdown-Test'),
                  ),
                ),
                Stack(
                  children: [
                    const VerticalDivider(
                      width: 32,
                      thickness: 1.8,
                      color: Color(0xFF534e52),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: IconButton(
                        color: const Color(0xFFf5cc67),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.arrow_right_arrow_left,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
                const Expanded(
                  flex: 1,
                  child: MarkdownPreview(
                    editorKey: ValueKey('App-Text-Test'),
                  ),
                ),
              ],
            ),
          ),
          const TitleBar()
        ],
      ),
    );
  }
}
