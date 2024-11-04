import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';
import 'package:flutter/material.dart';

part 'palette.tailor.dart';

@TailorMixin(themeGetter: ThemeGetter.onBuildContext)
class Palette extends ThemeExtension<Palette> with _$PaletteTailorMixin {
  Palette({
    required this.primary,
    required this.card,
  });

  final Color primary;
  final Color card;

  factory Palette.light() {
    return Palette(
      primary: const Color(0xFF008BEE),
      card: const Color(0xFFDCDCDC),
    );
  }

  factory Palette.dark() {
    return Palette(
      primary: const Color(0xFF008BEE),
      card: const Color(0xFF333333),
    );
  }
}
