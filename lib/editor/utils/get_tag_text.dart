import 'package:super_editor/super_editor.dart';

String tagTextFromAttr(Attribution attr) {
  switch (attr) {
    case boldAttribution:
      return '**';
    case italicsAttribution:
      return '**';
    default:
      return '';
  }
}
