import 'package:flutter/material.dart';
import 'package:job_search_app/core/themes/palette.dart';

class Themes {
  static final light =
      ThemeData.light().copyWith(extensions: [Palette.light()]);

  static final dark = ThemeData.dark().copyWith(extensions: [Palette.dark()]);
}
