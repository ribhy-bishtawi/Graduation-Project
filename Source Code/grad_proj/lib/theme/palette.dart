import 'package:flutter/material.dart';

class Palette {
  // Colors
  static const splashBackground = Color(0xFFFFAE53);
  static const primary = Color(0xFF804D00);

  static const black = Colors.black;
  static const designBlack = Color(0xFF272932);
  static const searchInputBackground = Color(0xFFFAFAFA);
  static const searchInputBorder = Color(0xFFEAEAEA);
  static const listItemBorder = Color(0xFFE9ECEF);
  static const textInputFocusedBorder = Color(0xFFDFD7CA);
  static const textInputHintColor = Color(0xFF212529);
  static const primaryButtonDisabledBackground = Color(0xFFBBA17A);
  static const secondaryButtonBackground = Color(0xFFF9F6F1);
  static const secondaryTextColor = Color(0xFFAFA9A0);
  static const secondary = Color(0xFF999794);
  static const shopDetailsText = Color(0xFF696969);
  static const daysColor = Color(0xFF89837B);

  static const textInputBackground = Color(0xFFF4F3F1);
  static const addShopTextInput = Color(0xAAA8A197);
  static const otpInputBackground = Color(0xFFF5F5F5);
  static const createAccountInputFocused = Color(0xFF18A413);
  static const genderUnselectedBorder = Color(0xFFF2F2F2);
  static const textInputText = Color(0xFF1A1A1A);
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Color(0xFFFFFFFF);
  static const scaffoldBackground = Color(0xFFF6F5F3);
  static const textInputError = Color(0xFFEB4A4A);
  static const settingsIconTint = Color(0xFFAEA18D);
  static const settingsTitleText = Color(0xFF495057);
  static const textFieldIcon = Color(0xFF8a8c8d);
  static const warning = Color(0xFFFF6E5D);
  static const cancelText = Color(0xFF54555B);

  static var theme = ThemeData(primarySwatch: createMaterialColor(primary));
  static var lightModeAppTheme = theme.copyWith(
    primaryColorLight: primary,
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: black,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: primary,

    // todo: remove this
    backgroundColor: whiteColor,
  );

  static MaterialColor createMaterialColor(Color color) {
    List<int> strengths = <int>[
      50,
      100,
      200,
      300,
      400,
      500,
      600,
      700,
      800,
      900
    ];
    Map<int, Color> swatch = {};

    for (int strength in strengths) {
      final double weight = 0.5 - ((strength / 1000.0) / 2.0);
      final int blend = (1.0 - weight).round();
      swatch[strength] = Color.fromRGBO(
        color.red + ((blend - color.red) * weight).round(),
        color.green + ((blend - color.green) * weight).round(),
        color.blue + ((blend - color.blue) * weight).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}
