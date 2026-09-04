import 'package:flutter/material.dart';

abstract final class DierbPalette {
  static const primary = Color(0xFF123A63);
  static const primaryDark = Color(0xFF0B1F3A);
  static const secondary = Color(0xFF2F6FA3);
  static const accent = Color(0xFFC9893A);
  static const background = Color(0xFFF7F9FC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFF0F4F8);
  static const text = Color(0xFF172033);
  static const muted = Color(0xFF667085);
  static const border = Color(0xFFD9E1EA);
  static const success = Color(0xFF23885D);
  static const danger = Color(0xFFC2413B);
}

abstract final class DierbTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: DierbPalette.primary, brightness: Brightness.light, surface: DierbPalette.surface, error: DierbPalette.danger).copyWith(primary: DierbPalette.primary, secondary: DierbPalette.accent);
    final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(18));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: DierbPalette.background,
      fontFamily: 'Kiwi',
      appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0, centerTitle: false, backgroundColor: DierbPalette.background, foregroundColor: DierbPalette.text, titleTextStyle: TextStyle(color: DierbPalette.text, fontSize: 21, fontWeight: FontWeight.w900)),
      cardTheme: CardThemeData(elevation: 0, color: DierbPalette.surface, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: DierbPalette.border))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: DierbPalette.surface, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: DierbPalette.border)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: DierbPalette.secondary, width: 1.5))),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: DierbPalette.primary, foregroundColor: Colors.white, minimumSize: const Size(48, 52), shape: rounded, textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: DierbPalette.primary, minimumSize: const Size(48, 52), shape: rounded, side: const BorderSide(color: DierbPalette.border), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800))),
      chipTheme: ChipThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: DierbPalette.border), backgroundColor: DierbPalette.surfaceSoft, labelStyle: const TextStyle(color: DierbPalette.text, fontWeight: FontWeight.w800)),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: DierbPalette.surface, modalBackgroundColor: DierbPalette.surface, showDragHandle: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28)))),
      navigationBarTheme: NavigationBarThemeData(height: 72, backgroundColor: DierbPalette.surface, indicatorColor: const Color(0xFFE7EEF6), labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: states.contains(WidgetState.selected) ? DierbPalette.primary : DierbPalette.muted, fontSize: 12, fontWeight: states.contains(WidgetState.selected) ? FontWeight.w900 : FontWeight.w700))),
      dividerTheme: const DividerThemeData(color: DierbPalette.border, thickness: 1),
    );
  }
}
