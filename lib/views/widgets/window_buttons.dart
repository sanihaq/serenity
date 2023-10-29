import 'package:flutter/cupertino.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _WindowButton(),
          _WindowButton(),
          _WindowButton(),
        ],
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  const _WindowButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: Color.fromARGB(50, 255, 255, 255),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
