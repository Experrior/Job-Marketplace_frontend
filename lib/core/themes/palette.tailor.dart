// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element, unnecessary_cast

part of 'palette.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$PaletteTailorMixin on ThemeExtension<Palette> {
  Color get primary;

  @override
  Palette copyWith({
    Color? primary,
  }) {
    return Palette(
      primary: primary ?? this.primary,
    );
  }

  @override
  Palette lerp(covariant ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) return this as Palette;
    return Palette(
      primary: Color.lerp(primary, other.primary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Palette &&
            const DeepCollectionEquality().equals(primary, other.primary));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(primary),
    );
  }
}

extension PaletteBuildContext on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}
