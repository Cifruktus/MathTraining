import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme.freezed.dart';

const Color primaryColor = Color(0xFFC56C35);
const Color secondaryColor = Color(0xFF8B0145);
const Color textOnWhiteColor = Color(0xFF3D1220);
const Color mistakeHighlightColor = Color(0xFFD45562);

const MaterialColor primaryColorSwatch = MaterialColor(0xFFC56C35, <int, Color>{
  50: Color(0xFFF8EDE7),
  100: Color(0xFFEED3C2),
  200: Color(0xFFE2B69A),
  300: Color(0xFFD69872),
  400: Color(0xFFCE8253),
  500: Color(0xFFC56C35),
  600: Color(0xFFBF6430),
  700: Color(0xFFB85928),
  800: Color(0xFFB04F22),
  900: Color(0xFFA33D16),
});

ThemeData materialThemeData = ThemeData(
  fontFamily: "JetBrainsMono",
  primarySwatch: primaryColorSwatch,
  extensions: [
    AppTheme(customThemeData)
  ],
);

AppThemeData customThemeData = AppThemeData(
  primaryColor: primaryColor,
  secondaryColor: secondaryColor,
  textOnWhiteColor: textOnWhiteColor,
  mistakeHighlightColor: mistakeHighlightColor,
  cardText: TextStyle(
    fontSize: 18,
  ),
  cardTextHighlighted: TextStyle(
    fontSize: 18,
    color: primaryColor,
    fontWeight: FontWeight.bold,
  ),

  homePageMainStatText: new TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  homePageStatText: new TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  cardTitleText: new TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
);

class AppTheme extends ThemeExtension<AppTheme> {
  final AppThemeData data;

  AppTheme(this.data);

  @override
  ThemeExtension<AppTheme> copyWith({AppThemeData? data}) {
    return AppTheme(data ?? this.data);
  }

  @override
  ThemeExtension<AppTheme> lerp(covariant ThemeExtension<AppTheme>? other, double t) {
    throw UnimplementedError();
  }

}

@freezed
abstract class AppThemeData with _$AppThemeData {
  const factory AppThemeData({
    required Color primaryColor,
    required Color secondaryColor,
    required Color textOnWhiteColor,
    required Color mistakeHighlightColor,
    required TextStyle cardText,
    required TextStyle cardTextHighlighted,
    required TextStyle homePageStatText,
    required TextStyle homePageMainStatText,
    required TextStyle cardTitleText,
  }) = _AppThemeData;
}
