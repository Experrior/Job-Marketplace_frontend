// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element, unnecessary_cast

part of 'palette.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$PaletteTailorMixin on ThemeExtension<Palette> {
  Color get primary;
  Color get card;
  Color get tagOnCardBackground;

  @override
  Palette copyWith({
    Color? primary,
    Color? card,
    Color? tagOnCardBackground,
  }) {
    return Palette(
      primary: primary ?? this.primary,
      card: card ?? this.card,
      tagOnCardBackground: tagOnCardBackground ?? this.tagOnCardBackground,
    );
  }

  @override
  Palette lerp(covariant ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) return this as Palette;
    return Palette(
      primary: Color.lerp(primary, other.primary, t)!,
      card: Color.lerp(card, other.card, t)!,
      tagOnCardBackground:
          Color.lerp(tagOnCardBackground, other.tagOnCardBackground, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Palette &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(card, other.card) &&
            const DeepCollectionEquality()
                .equals(tagOnCardBackground, other.tagOnCardBackground));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(card),
      const DeepCollectionEquality().hash(tagOnCardBackground),
    );
  }
}

extension PaletteBuildContext on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}
