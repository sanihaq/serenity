import 'dart:io';

import 'package:flutter/material.dart';
import 'package:serenity/views/widgets/window_buttons.dart';

import '../../styles/ui_sizes.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appTitleBarHeight,
      child: Row(
        children: [
          if (Platform.isMacOS) const WindowButtons(),
          Expanded(child: Container()),
          if (Platform.isWindows) const WindowButtons(),
        ],
      ),
    );
  }
}
