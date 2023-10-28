import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../../themes/apple_dark.dart';

Stylesheet buildStylesheet(Stylesheet stylesheet) {
  return stylesheet.copyWith(
    inlineTextStyler: (attributions, existingStyle) {
      existingStyle = existingStyle.copyWith(
        fontFamily: 'SFPro',
        fontSize: 15,
      );
      final attributionType = attributions.firstOrNull?.id;
      if (attributionType == null) return existingStyle;
      switch (attributionType) {
        case 'bold':
          return existingStyle.copyWith(
            color: const Color(0xFFBAE67E),
            fontWeight: FontWeight.bold,
          );
        case 'italics':
          return existingStyle.copyWith(
            color: const Color(0xFF95E6CB),
            fontStyle: FontStyle.italic,
          );
        case 'paragraph':
          return existingStyle.copyWith(color: appleDark.editor.textColor);

        default:
          debugPrint('"$attributionType" not implemented');
      }

      return existingStyle.copyWith(color: appleDark.editor.textColor);
    },
  );
}
