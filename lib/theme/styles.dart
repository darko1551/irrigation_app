import 'package:flutter/material.dart';

class Styles {
  static ThemeData lightTheme = ThemeData(
    secondaryHeaderColor: const Color.fromARGB(255, 0, 69, 146),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 203, 218, 225),
    ),
    hintColor: Colors.grey[700],
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 247, 245, 245),
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
      contentTextStyle: TextStyle(color: Colors.black, fontSize: 17),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 0, 69, 146)),
    primaryColor: const Color.fromARGB(255, 0, 69, 146),
    cardColor: const Color.fromARGB(255, 247, 245, 245),
    indicatorColor: Colors.cyan,
    scaffoldBackgroundColor: const Color.fromARGB(255, 203, 218, 225),
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 69, 146)),
    disabledColor: Colors.grey,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 0, 69, 146),
      foregroundColor: Color.fromARGB(255, 231, 231, 231),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 0, 69, 146),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black)),
  );

  static ThemeData darkTheme = ThemeData(
    dividerColor: Colors.white,
    secondaryHeaderColor: const Color.fromARGB(255, 119, 211, 235),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
    ),
    hintColor: Colors.grey[400],
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 66, 66, 66),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 17),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 128, 191, 226)),
    primaryColor: const Color.fromARGB(255, 41, 41, 41),
    cardColor: const Color.fromARGB(255, 66, 66, 66),
    indicatorColor: Colors.cyan,
    scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 191, 226)),
    disabledColor: const Color.fromARGB(255, 192, 190, 190),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 128, 191, 224),
        ),
        foregroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 18, 18, 18),
        ),
      ),
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white)),
  );

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    if (isDarkTheme) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }
}
