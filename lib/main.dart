import 'package:flutter/material.dart';
import 'package:serenity/models/app_routes.dart';
import 'package:serenity/themes/apple_dark.dart';
import 'package:window_manager/window_manager.dart';

import 'scenes/markdown_test_scene.dart';
import 'utils/color_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SFPro',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: getMaterialColor(
            appleDark.editor.tintColor,
          ),
        ).copyWith(
          background: appleDark.editor.backgroundColor,
        ),
        textTheme: const TextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.markdownTest.name,
      routes: {
        AppRoutes.markdownTest.name: (context) => const MarkdownTestScene(),
      },
    );
  }
}
