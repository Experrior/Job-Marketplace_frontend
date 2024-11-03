import 'package:flutter/material.dart';

import 'package:macos_ui/macos_ui.dart';

import 'logo.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      child: child,
    );
  }
}
