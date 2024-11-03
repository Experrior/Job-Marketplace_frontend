import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import 'core/app.dart';

Future<void> main() async{
  await configureMacosWindowUtils();
  runApp(const ProviderScope(child: JobSearchApp()));
}

Future<void> configureMacosWindowUtils() async {

  const config = MacosWindowUtilsConfig();
  await config.apply();
}