import 'package:flutter/material.dart';

abstract final class DierbTheme {
  static const primary = Color(0xFF123A63);
  static const primaryDark = Color(0xFF0B1F3A);
  static const secondary = Color(0xFF2F6FA3);
  static const accent = Color(0xFFC9893A);
  static const background = Color(0xFFF7F9FC);
  static const surfaceSoft = Color(0xFFF0F4F8);
  static const text = Color(0xFF172033);
  static const muted = Color(0xFF667085);
  static const border = Color(0xFFD9E1EA);

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, surface: Colors.white, error: const Color(0xFFC2413B)).copyWith(primary: primary, secondary: accent),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0, centerTitle: false, backgroundColor: background, foregroundColor: text, titleTextStyle: TextStyle(color: text, fontSize: 21, fontWeight: FontWeight.w900)),
    cardTheme: CardThemeData(elevation: 0, color: Colors.white, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: border))),
    inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: border)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: secondary, width: 1.5))),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, minimumSize: const Size(48, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), textStyle: const TextStyle(fontWeight: FontWeight.w900))),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: primary, minimumSize: const Size(48, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: const BorderSide(color: border), textStyle: const TextStyle(fontWeight: FontWeight.w800))),
    chipTheme: ChipThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: border), backgroundColor: surfaceSoft, labelStyle: const TextStyle(color: text, fontWeight: FontWeight.w800)),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white, modalBackgroundColor: Colors.white, showDragHandle: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28)))),
    dividerTheme: const DividerThemeData(color: border),
  );
}
