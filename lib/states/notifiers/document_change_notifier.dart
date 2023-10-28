import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

class DocumentChangeNotifier extends ValueNotifier<DocumentChangeLog> {
  static final DocumentChangeNotifier _shared = DocumentChangeNotifier._sharedInstance();
  factory DocumentChangeNotifier() => _shared;
  DocumentChangeNotifier._sharedInstance() : super(DocumentChangeLog([]));

  void change(DocumentChangeLog changelog) {
    value = changelog;
  }
}
