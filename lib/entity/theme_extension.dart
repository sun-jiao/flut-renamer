import 'package:flutter/material.dart';

class FileListColors extends ThemeExtension<FileListColors> {
  FileListColors({
    required this.primaryColor,
    required this.secondaryColor,
  });

  final Color primaryColor;
  final Color secondaryColor;

  @override
  ThemeExtension<FileListColors> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
  }) =>
      FileListColors(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
      );

  @override
  ThemeExtension<FileListColors> lerp(
    covariant ThemeExtension<FileListColors>? other,
    double t,
  ) {
    if (other is! FileListColors) {
      return this;
    }

    return FileListColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t) ?? primaryColor,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t) ?? secondaryColor,
    );
  }
}
