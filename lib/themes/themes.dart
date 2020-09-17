import 'package:flutter/material.dart';

class VirusMapBRTheme {
  // Light Theme Colors
  static Map<String, Color> lightColors = {
    // Key Colors
    "primary": Color(0xFF3399FF),
    "secondary": Color(0xFF297ACC),

    // Surface Colors
    "background": Color(0xFFFFFFFF),
    "surface": Color(0xFF3399FF),
    "highlight": Color(0xFFF0F0F0),
    "modal": Color(0xFFFFFFFF),

    // Semantic Colors
    "error": Color(0xFFFF3333),
    "alert": Color(0xFFFFBB33),
    "success": Color(0xFF09E689),
    "accent": Color(0xFF7733FF),

    // Text/Icon color on Primary/Accent/Surface/Semantic
    "text": Color(0xFFFFFFFF),

    // Text/Icon colors on Background/Modal/Highlight
    "text0": Color(0xFF000000),
    "text1": Color(0xFF1A1A1A),
    "text2": Color(0xFF404040),
    "text3": Color(0xFF808080),
    "text4": Color(0xFFCCCCCC),
    "text5": Color(0xFFFFFFFF),
    "disabled": Color(0xFFE6E6E6),

    // Basic Colors
    "grey": Color(0xFF808080),
    "red": Color(0xFFE64545),
    "orange": Color(0xFFFFB045),
    "yellow": Color(0xFFD6D045),
    "green": Color(0xFF3dcc90),
    "cyan": Color(0xFF45E5E5),
    "blue": Color(0xFF4595E5),
    "purple": Color(0xFF7A45E6),

    // Neutral Colors
    "black": Color(0xFF000000),
    "white": Color(0xFFFFFFFf),
  };

  // Dark Theme Colors
  static Map<String, Color> darkColors = {
    // Key Colors
    "primary": Color(0xFF4595E5),
    "secondary": Color(0xFF3574B2),

    // Surface Colors
    "background": Color(0xFF171E26),
    "surface": Color(0xFF050F19),
    "highlight": Color(0xFF2E3D4C),
    "modal": Color(0xFF263340),

    // Semantic Colors
    "error": Color(0xFFFF9999),
    "alert": Color(0xFFFFDD99),
    "success": Color(0xFF99FFD4),
    "accent": Color(0xFFBB99FF),

    // Text/Icon color on Primary/Accent/Surface/Semantic
    "text": Color(0xFFFFFFFF),

    // Text/Icon colors on Background/Modal/Highlight
    "text0": Color(0xFFFFFFFF),
    "text1": Color(0xFFFAFAFA),
    "text2": Color(0xFFE6E6E6),
    "text3": Color(0xFFCCCCCC),
    "text4": Color(0xFF808080),
    "text5": Color(0xFF000000),
    "disabled": Color(0xFF3D5266),

    // Basic Colors
    "grey": Color(0xFF808080),
    "red": Color(0xFFE64545),
    "orange": Color(0xFFFFB045),
    "yellow": Color(0xFFD6D045),
    "green": Color(0xFF3dcc90),
    "cyan": Color(0xFF45E5E5),
    "blue": Color(0xFF4595E5),
    "purple": Color(0xFF7A45E6),

    // Neutral Colors
    "black": Color(0xFF000000),
    "white": Color(0xFFFFFFFf),
  };

  // Get the ThemeData for given brightness
  static ThemeData getTheme(Brightness brightness) {
    var colors;
    switch (brightness) {
      case Brightness.light:
        colors = lightColors;
        break;
      case Brightness.dark:
        colors = darkColors;
        break;
      default:
        brightness = Brightness.light;
        colors = lightColors;
    }

    return ThemeData(
      colorScheme: ColorScheme(
        primary: colors["primary"],
        primaryVariant: colors["primary"],
        secondary:  colors["secondary"],
        secondaryVariant: colors["secondary"],
        surface: colors["surface"],
        background: colors["background"],
        error: colors["error"],
        onPrimary: colors["text"],
        onSecondary: colors["text"],
        onSurface: colors["text1"],
        onBackground: colors["text1"],
        onError: colors["text"],
        brightness: brightness,
      ),

      //brightness: brightness,
      primaryColor: colors["primary"],
      accentColor: colors["secondary"],

      backgroundColor: colors["background"],
      scaffoldBackgroundColor: colors["background"],
      canvasColor: colors["background"],
      errorColor: colors["error"],
      
      toggleableActiveColor: colors["primary"],
      unselectedWidgetColor: colors["text3"],
      disabledColor: colors["disabled"],
      buttonColor: colors["primary"],
      splashColor: colors["primary"],
      
      fontFamily: "Muli",
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: colors["text1"]),
        headline2: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: colors["text1"]),
        headline3: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: colors["text1"]),
        headline4: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: colors["text1"]),
        headline5: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.normal,
            color: colors["text1"]),
        headline6: TextStyle(
            fontFamily: "Roboto",
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: colors["text1"]),
        bodyText1: TextStyle(
            fontFamily: "Roboto",
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: colors["text1"]),
        subtitle1: TextStyle(
            fontFamily: "Roboto",
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: colors["text1"]),
        bodyText2: TextStyle(
            fontFamily: "Roboto",
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: colors["text1"]),
        subtitle2: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: colors["text1"]),
        caption: TextStyle(
            fontFamily: "Roboto",
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: colors["text1"]),
        button: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: colors["text1"]),
        overline: TextStyle(
            fontFamily: "Roboto",
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: colors["text1"]),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors["primary"],
        foregroundColor: colors["text"],
        elevation: 6,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colors["primary"],
        disabledColor: colors["text4"],
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            fontFamily: "Roboto",
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: colors["text3"]),
        hintStyle: TextStyle(
            fontFamily: "Roboto",
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: colors["text3"]),
        helperStyle: TextStyle(
            fontFamily: "Roboto",
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: colors["text3"]),
        errorStyle: TextStyle(
            fontFamily: "Roboto",
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: colors["error"]),
        contentPadding: EdgeInsets.fromLTRB(12.0,8.0,16.0,8.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colors["text4"]),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors["text4"]),
        ),
        filled: true,
        fillColor: colors["highlight"],
      ),
      dialogBackgroundColor: colors["highlight"],
    );
  }

  // Get the theme colors for a given brightness
  static Color color(BuildContext context, String key, [String altKey]) {
    Brightness brightness = Theme.of(context).colorScheme.brightness;
    var colors;
    switch (brightness) {
      case Brightness.light:
        colors = lightColors;
        break;
      case Brightness.dark:
        colors = darkColors;
        if (altKey != null) key = altKey;
        break;
      default:
        brightness = Brightness.light;
        colors = lightColors;
    }
    return colors[key];
  }

  static bool isLight(BuildContext context) {
    Brightness brightness = Theme.of(context).colorScheme.brightness;
    return brightness == Brightness.light;
  }

  static bool isDark(BuildContext context) {
    Brightness brightness = Theme.of(context).colorScheme.brightness;
    return brightness == Brightness.dark;
  }

}
