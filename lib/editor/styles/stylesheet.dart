import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../../styles/apple_dark.dart';

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

        case 'inline-bold-tag':
          return existingStyle.copyWith(
            color: const Color(0xFFBAE67E).withOpacity(0.5),
            fontWeight: FontWeight.bold,
          );
        case 'inline-bold-value-tag':
          return existingStyle.copyWith(
            color: const Color(0xFFBAE67E),
            fontWeight: FontWeight.bold,
          );
        case 'inline-italic-tag':
          return existingStyle.copyWith(
            color: const Color(0xFF95E6CB).withOpacity(0.5),
            fontStyle: FontStyle.italic,
          );
        case 'inline-italic-value-tag':
          return existingStyle.copyWith(
            color: const Color(0xFF95E6CB),
            fontStyle: FontStyle.italic,
          );

        case 'markdown-inline-tag':
          return existingStyle.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: 22,
            color: const Color(0xFF95E6CB).withOpacity(0.3),
          );

        default:
          debugPrint('"$attributionType" not implemented');
      }

      return existingStyle.copyWith(color: appleDark.editor.textColor);
    },
  );
}
