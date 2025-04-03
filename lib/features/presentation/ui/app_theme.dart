import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // final ThemeData darkTheme = ThemeData(
  //   brightness: Brightness.dark,
  //   colorScheme: ColorScheme.fromSeed(
  //     seedColor: Colors.deepOrange,
  //     brightness: Brightness.dark,
  //   ),
  //   useMaterial3: true,
  //   visualDensity: VisualDensity.adaptivePlatformDensity,
  //   scaffoldBackgroundColor: Colors.black,
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: Colors.black,
  //     foregroundColor: Colors.white,
  //     elevation: 0,
  //   ),
  //   textTheme: const TextTheme(
  //     bodyLarge: TextStyle(color: Colors.white),
  //     bodyMedium: TextStyle(color: Colors.white70),
  //     bodySmall: TextStyle(color: Colors.white60),
  //     headlineMedium: TextStyle(color: Colors.white),
  //     headlineSmall: TextStyle(color: Colors.white70),
  //   ),
  //   cardTheme: CardTheme(
  //     color: Colors.grey[900],
  //     shadowColor: Colors.black54,
  //     elevation: 2,
  //   ),
  //   inputDecorationTheme: InputDecorationTheme(
  //     filled: true,
  //     fillColor: Colors.grey[850],
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(8),
  //       borderSide: const BorderSide(color: Colors.white30),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(8),
  //       borderSide: const BorderSide(color: Colors.deepOrangeAccent),
  //     ),
  //     hintStyle: const TextStyle(color: Colors.white54),
  //     labelStyle: const TextStyle(color: Colors.white70),
  //   ),
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.deepOrange,
  //       foregroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //   ),
  //   iconTheme: const IconThemeData(color: Colors.white),
  //   textButtonTheme: TextButtonThemeData(
  //     style: TextButton.styleFrom(
  //       foregroundColor: Colors.deepOrange,
  //       backgroundColor: Colors.grey,
  //     ),
  //   ),
  //   outlinedButtonTheme: OutlinedButtonThemeData(
  //     style: ButtonStyle(
  //       padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
  //       side: WidgetStateProperty.all<BorderSide>(
  //         const BorderSide(color: Colors.deepOrange),
  //       ),
  //       shape: WidgetStateProperty.all<OutlinedBorder>(
  //         const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.zero,
  //         ), // No border radius
  //       ),
  //     ),
  //   ),
  // );

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black87),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.grey.shade300,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.deepOrange),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.black54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
    // ),
  );

  // New method to get BoxDecoration for different themes
  BoxDecoration getBoxDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return BoxDecoration(
      color:
          isDarkTheme
              ? theme.colorScheme.surfaceBright
              : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
      boxShadow:
          isDarkTheme
              ? [
                const BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ]
              : [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
    );
  }

  // Method to get adaptive button style
  ButtonStyle getAdaptiveButtonStyle(
    BuildContext context, {
    required bool isSelected,
    TextStyle? defaultTextStyle,
  }) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        isDarkTheme
            ? isSelected
                ? Colors.white24
                : Colors.transparent
            : isSelected
            ? theme.colorScheme.shadow
            : Colors.transparent,
      ),
      foregroundColor: WidgetStateProperty.all(
        isDarkTheme
            ? isSelected
                ? Colors.white
                : defaultTextStyle?.color ?? theme.textTheme.bodyMedium?.color
            : isSelected
            ? Colors.black
            : defaultTextStyle?.color ?? theme.textTheme.bodyMedium?.color,
      ),
    );
  }
}

class AppTypography {
  //Text styles with Google Theme
  TextStyle appTitleStyle = GoogleFonts.bungeeSpice(
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );

  TextStyle appSubTitleStyle = GoogleFonts.eduVicWaNtBeginner(
    color: Colors.grey,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  TextStyle appMenuStyle = GoogleFonts.bungeeSpice(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  TextStyle bodyTextLarge = GoogleFonts.eduVicWaNtBeginner(
    color: Colors.grey,
    fontWeight: FontWeight.w700,
    fontSize: 28,
  );

  TextStyle bodyTextMedium = GoogleFonts.eduVicWaNtBeginner(
    color: Colors.grey,
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );

  TextStyle bodyTextSmall = GoogleFonts.eduVicWaNtBeginner(
    color: Colors.grey,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  TextStyle buttonTextLarge = GoogleFonts.eduVicWaNtBeginner(
    color: Colors.grey,
    fontWeight: FontWeight.w900,
    fontSize: 28,
  );

  TextStyle buttonTextMedium = GoogleFonts.eduVicWaNtBeginner(
    color: Colors.grey,
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );

  TextStyle buttonTextSmall = GoogleFonts.eduVicWaNtBeginner(
    color: Colors.grey,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );
}
