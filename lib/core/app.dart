import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:job_search_app/core/router/router.dart';
import 'package:job_search_app/core/themes/themes.dart';

import 'package:macos_ui/macos_ui.dart';

class JobSearchApp extends HookWidget {
  const JobSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.system,
      home: MacosApp.router(
        title: 'Job Search App',
        theme: Themes.macosLight,
        darkTheme: Themes.macosDark,
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}
