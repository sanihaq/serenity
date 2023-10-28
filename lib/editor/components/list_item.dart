import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../../styles/apple_dark.dart';

class ListItemCustomComponentBuilder extends ListItemComponentBuilder {
  const ListItemCustomComponentBuilder();

  @override
  Widget? createComponent(
    SingleColumnDocumentComponentContext componentContext,
    SingleColumnLayoutComponentViewModel componentViewModel,
  ) {
    if (componentViewModel is! ListItemComponentViewModel) {
      return null;
    }
    if (componentViewModel.type == ListItemType.unordered) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3, left: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appleDark.editor.tintColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextComponent(
              key: componentContext.componentKey,
              text: componentViewModel.text,
              textStyleBuilder: (attr) => componentViewModel
                  .textStyleBuilder(attr)
                  .copyWith(color: appleDark.editor.textColor),
              textSelection: componentViewModel.selection,
              selectionColor: componentViewModel.selectionColor,
              highlightWhenEmpty: componentViewModel.highlightWhenEmpty,
            ),
          ),
        ],
      );
    }
    return null;
  }
}
