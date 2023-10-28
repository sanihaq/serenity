import 'package:flutter/widgets.dart';

class AppTheme {
  final String name;
  final EditorTheme editor;
  // final EditorStyles styles;

  const AppTheme({
    required this.name,
    required this.editor,
  });
}

class EditorStyles {
  TextStyle body;
  TextStyle? title1;
  TextStyle? title2;
  TextStyle? title3;
  TextStyle? title4;
  TextStyle? workingOn;
  TextStyle? flagged1;
  TextStyle? flagged2;
  TextStyle? flagged3;
  TextStyle? titleMark1;
  TextStyle? titleMark2;
  TextStyle? titleMark3;
  TextStyle? titleMark4;
  TextStyle? bold;
  TextStyle? boldLeftMark;
  TextStyle? boldRightMark;
  TextStyle? italic;
  TextStyle? italicLeftMark;
  TextStyle? italicRightMark;
  TextStyle? boldItalic;
  TextStyle? boldItalicLeftMark;
  TextStyle? boldItalicRightMark;
  TextStyle? code;
  TextStyle? codeLeftBacktick;
  TextStyle? codeRightBacktick;
  EditorStyles({
    required this.body,
    this.title1,
    this.title2,
    this.title3,
    this.title4,
    this.workingOn,
    this.flagged1,
    this.flagged2,
    this.flagged3,
    this.titleMark1,
    this.titleMark2,
    this.titleMark3,
    this.titleMark4,
    this.bold,
    this.boldLeftMark,
    this.boldRightMark,
    this.italic,
    this.italicLeftMark,
    this.italicRightMark,
    this.boldItalic,
    this.boldItalicLeftMark,
    this.boldItalicRightMark,
    this.code,
    this.codeLeftBacktick,
    this.codeRightBacktick,
  });
}

class EditorTheme {
  final Color backgroundColor;
  final Color altBackgroundColor;
  final Color tintColor;
  final Color tintColor2;
  final Color textColor;
  final Color toolbarBackgroundColor;
  final Color toolbarIconColor;
  final Color menuItemColor;
  final Color timeBlockColor;
  final bool shouldOverwriteFont;

  const EditorTheme({
    required this.backgroundColor,
    required this.altBackgroundColor,
    required this.tintColor,
    required this.tintColor2,
    required this.textColor,
    required this.toolbarBackgroundColor,
    required this.toolbarIconColor,
    required this.menuItemColor,
    required this.timeBlockColor,
    required this.shouldOverwriteFont,
  });
}
