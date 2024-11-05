import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app/core/themes/palette.dart';

import 'package:macos_ui/macos_ui.dart';

class Themes {
  static final MacosThemeData macosLight = MacosThemeData.light().copyWith(
    primaryColor: Colors.deepPurpleAccent,
    accentColor: AccentColor.purple,
  );
  static final MacosThemeData macosDark = MacosThemeData.dark().copyWith(
    primaryColor: Colors.deepPurpleAccent,
    accentColor: AccentColor.purple,
  );

  static final light = ThemeData.light().copyWith(
    extensions: [Palette.light()],
    primaryColor: Palette.light().primary,
    colorScheme: ColorScheme.fromSeed(seedColor: Palette.light().primary),
  );

  static final dark = ThemeData.dark().copyWith(
    extensions: [Palette.dark()],
    primaryColor: Palette.dark().primary,
    colorScheme: ColorScheme.fromSeed(seedColor: Palette.dark().primary),
  );
}
