import 'package:flutter/material.dart';
import 'package:job_search_app/core/themes/palette.dart';

class Themes {
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
