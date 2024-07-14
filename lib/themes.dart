import 'package:flutter/material.dart';

class MocaThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
  static TextTheme lightTextTheme = _textTheme(lightColorScheme, _lightFocusColor);
  static TextTheme darkTextTheme = _textTheme(lightColorScheme, _lightFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    TextTheme textTheme = _textTheme(colorScheme, focusColor);
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
        titleTextStyle: textTheme.headlineLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 5,
        backgroundColor: colorScheme.surface,
        height: 70,
        indicatorColor: colorScheme.primary,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
        shadowColor: colorScheme.shadow,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: textTheme.titleMedium!.apply(color: _darkFillColor),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        fillColor: Colors.transparent,
        color: colorScheme.onSurface,
        highlightColor: Colors.transparent,
        selectedColor: colorScheme.surface,
        splashColor: Colors.transparent,
        textStyle: textTheme.labelSmall,
      ),

      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(),
      ),
      //
      iconTheme: IconThemeData(color: colorScheme.onBackground),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    //
    background: const Color(0xFFFFFDF5),
    // background: Colors.teal.shade300,
    onBackground: Colors.black,
    //
    primary: const Color(0xFF8AC894),
    onPrimary: Colors.white,
    //
    primaryContainer: const Color(0xFF8AC894),
    onPrimaryContainer: Colors.black,
    //
    secondary: const Color(0xFFEEEEEE),
    onSecondary: Colors.white,
    //
    secondaryContainer: const Color(0xFF8AC894),
    onSecondaryContainer: Colors.black,
    //
    shadow: Colors.grey.withOpacity(0.5),
    //
    error: const Color(0xffFF5449),
    onError: Colors.black,
    //
    surface: Colors.white,
    onSurface: Colors.black,
    //
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFFF8383),
    primaryContainer: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryContainer: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static TextTheme _textTheme(ColorScheme colorScheme, Color focusColor) {
    const light = FontWeight.w100;
    const regular = FontWeight.w200;
    const medium = FontWeight.w300;
    const semiBold = FontWeight.w400;
    const bold = FontWeight.w500;
    const extrabold = FontWeight.w700;
    const heavy = FontWeight.w900;

    return TextTheme(
      displayLarge: const TextStyle(fontFamily: "SUITE", fontWeight: regular, fontSize: 57.0),
      displayMedium: const TextStyle(fontFamily: "SUITE", fontWeight: regular, fontSize: 45.0),
      displaySmall: const TextStyle(fontFamily: "SUITE", fontWeight: regular, fontSize: 36.0),
      //
      headlineLarge: const TextStyle(fontFamily: "SUITE", fontWeight: medium, fontSize: 32.0),
      headlineMedium: const TextStyle(fontFamily: "SUITE", fontWeight: semiBold, fontSize: 28.0),
      headlineSmall: const TextStyle(fontFamily: "SUITE", fontWeight: bold, fontSize: 24.0),
      //
      titleLarge: TextStyle(fontFamily: "SUITE", fontWeight: heavy, fontSize: 24.0, color: colorScheme.onPrimary),
      titleMedium: const TextStyle(fontFamily: "SUITE", fontWeight: extrabold, fontSize: 18.0),
      titleSmall: const TextStyle(fontFamily: "SUITE", fontWeight: medium, fontSize: 12.0),
      //
      labelLarge: TextStyle(fontFamily: "SUITE", fontWeight: bold, fontSize: 16.0, color: colorScheme.onPrimary),
      labelMedium: const TextStyle(fontFamily: "SUITE", fontWeight: medium, fontSize: 14.0),
      labelSmall: const TextStyle(fontFamily: "SUITE", fontWeight: light, fontSize: 12.0),
      //
      bodyLarge: const TextStyle(fontFamily: "SUITE", fontWeight: extrabold, fontSize: 16.0),
      bodyMedium: const TextStyle(fontFamily: "SUITE", fontWeight: semiBold, fontSize: 12.0),
      bodySmall: const TextStyle(fontFamily: "SUITE", fontWeight: medium, fontSize: 10.0),
    );
  }

  // static ThemeData lightThemeData = themeData();

  // static ThemeData themeData() {
  //   final base = ThemeData();

  //   return base.copyWith(
  //       colorScheme: _mocaColorScheme(base.colorScheme),
  //       textTheme: _mocaTextTheme(base.textTheme),
  //       bottomNavigationBarTheme: _mocaBottomNavigationBarThemeData(base.bottomNavigationBarTheme)

  //       // ...
  //       // textTheme 외에도 appBarTheme, primaryTheme, colorScheme 등 override 할 수 있는 항목 매우 많음
  //       );
  // }

  // static ColorScheme _mocaColorScheme(ColorScheme base) {
  //   return base.copyWith(
  //     brightness: Brightness.light,
  //     //
  //     background: Colors.white,
  //     onBackground: Colors.black,
  //     //
  //     primary: const Color(0xFF8AC894),
  //     onPrimary: Colors.white,
  //     //
  //     primaryContainer: Colors.white,
  //     onPrimaryContainer: Colors.black,
  //     //
  //     secondary: Colors.amber,
  //     onSecondary: Colors.white,
  //     //
  //     secondaryContainer: Colors.white,
  //     onSecondaryContainer: Colors.black,
  //     //
  //     shadow: Colors.grey.withOpacity(0.5),
  //     //
  //     error: const Color(0xffFF5449),
  //     onError: Colors.black,
  //     //
  //     // surface: Colors.white,
  //     // onSurface: Colors.black,
  //     //
  //   );
  // }

  // static TextTheme _mocaTextTheme(TextTheme base) {
  //   return base.copyWith(
  //     bodyLarge: const TextStyle(fontFamily: "SUITE"),
  //     bodySmall: const TextStyle(fontFamily: "SUITE"),
  //     bodyMedium: const TextStyle(fontFamily: "SUITE"),
  //     // bodyText1: const TextStyle(fontFamily: "SUITE"),
  //     // bodyText2: const TextStyle(fontFamily: "SUITE"),
  //     // button: const TextStyle(fontFamily: "SUITE"),
  //     // caption: const TextStyle(fontFamily: "SUITE"),
  //     displayLarge: const TextStyle(fontFamily: "SUITE"),
  //     displayMedium: const TextStyle(fontFamily: "SUITE"),
  //     displaySmall: const TextStyle(fontFamily: "SUITE"),
  //     // headline1: const TextStyle(fontFamily: "SUITE"),
  //     // headline2: const TextStyle(fontFamily: "SUITE"),
  //     // headline3: const TextStyle(fontFamily: "SUITE"),
  //     // headline4: const TextStyle(fontFamily: "SUITE"),
  //     // headline5: const TextStyle(fontFamily: "SUITE"),
  //     // headline6: const TextStyle(fontFamily: "SUITE"),
  //     headlineLarge: const TextStyle(fontFamily: "SUITE"),
  //     headlineMedium: const TextStyle(fontFamily: "SUITE"),
  //     headlineSmall: const TextStyle(fontFamily: "SUITE"),
  //     labelLarge: const TextStyle(fontFamily: "SUITE"),
  //     labelMedium: const TextStyle(fontFamily: "SUITE"),
  //     labelSmall: const TextStyle(fontFamily: "SUITE"),
  //     // overline: const TextStyle(fontFamily: "SUITE"),
  //     // subtitle1: const TextStyle(fontFamily: "SUITE"),
  //     // subtitle2: const TextStyle(fontFamily: "SUITE"),
  //     titleLarge: const TextStyle(fontFamily: "SUITE"),
  //     titleMedium: const TextStyle(fontFamily: "SUITE"),
  //     titleSmall: const TextStyle(fontFamily: "SUITE"),

  //     // titleLarge: const TextStyle(fontFamily: "SUITE"),
  //     // ...
  //   );
  // }

  // static BottomNavigationBarThemeData _mocaBottomNavigationBarThemeData(BottomNavigationBarThemeData base) {
  //   return base.copyWith(
  //     backgroundColor: base.backgroundColor,
  //     elevation: 0,
  //     enableFeedback: false,
  //     // landscapeLayout:
  //     // mouseCursor:
  //     selectedIconTheme: IconThemeData(),
  //     selectedItemColor: Colors.white,
  //     selectedLabelStyle: TextStyle(),
  //     showSelectedLabels: true,
  //     showUnselectedLabels: false,
  //     // type:
  //     unselectedIconTheme: IconThemeData(),
  //     unselectedItemColor: Colors.white,
  //     unselectedLabelStyle: TextStyle(),
  //   );
  // }
}

ThemeData mainTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    //
    background: Color(0xfff3eff5),
    onBackground: Color(0xff000000),
    //
    primary: Color(0xffab94d4),
    onPrimary: Color(0xff000000),
    //
    primaryContainer: Color(0xffffffff),
    onPrimaryContainer: Color(0xff000000),
    secondaryContainer: Color(0xfffaf8ff),
    //
    shadow: Color(0x7f9e9e9e),
    //
    secondary: Color(0xff6f579e),
    onSecondary: Color(0xff000000),
    //
    tertiary: Color(0xffffee70),
    onTertiary: Color(0xff000000),
    //
    error: Colors.red,
    onError: Color(0xff000000),
    //
    surface: Color(0xfff3eff5),
    onSurface: Color(0xff000000),
    //
  ),

  // ink splash animation
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
);
