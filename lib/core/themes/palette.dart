import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';
import 'package:flutter/material.dart';


part 'palette.tailor.dart';

@TailorMixin(themeGetter: ThemeGetter.onBuildContext)
class Palette extends ThemeExtension<Palette> with _$PaletteTailorMixin {
  Palette({
    required this.primary,
  });

  final Color primary;

  factory Palette.light() {
    return Palette(
      primary: const Color(0xFF008BEE),
    );
  }

  factory Palette.dark() {
    return Palette(
      primary: const Color(0xFF008BEE),
    );
  }
}
