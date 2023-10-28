import 'package:flutter/material.dart';

enum AppRoutes {
  markdownTest('/markdown-test'),
  ;

  final String name;
  const AppRoutes(this.name);

  void push(BuildContext context) {
    Navigator.of(context).pushNamed(name);
  }
}
