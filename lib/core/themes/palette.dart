import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';
import 'package:flutter/material.dart';

part 'palette.tailor.dart';

@TailorMixin(themeGetter: ThemeGetter.onBuildContext)
class Palette extends ThemeExtension<Palette> with _$PaletteTailorMixin {
  Palette({
    required this.primary,
    required this.card,
    required this.tagOnCardBackground,
  });

  final Color primary;
  final Color card;
  final Color tagOnCardBackground;

  factory Palette.light() {
    return Palette(
      primary: Colors.deepPurpleAccent,
      card: const Color(0xFFDCDCDC),
      tagOnCardBackground: const Color(0xFFCCCCCC),
    );
  }

  factory Palette.dark() {
    return Palette(
      primary: Colors.deepPurpleAccent,
      card: const Color(0xFF333333),
      tagOnCardBackground: const Color(0xFF444444),
    );
  }
}
