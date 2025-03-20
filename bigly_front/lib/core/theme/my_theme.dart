import 'package:flutter/material.dart';

class MyTheme {
  static TextStyle  smallGreyText = const TextStyle(fontSize: 12,color: Colors.grey);
  static TextStyle  smallBlackText = const TextStyle(fontSize: 12,color: Colors.black);
  static TextStyle  smallBlackBoldText = const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.black);
  static TextStyle  mediumBlackText =  const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black);
  static TextStyle  mediumBlackBoldText =  const TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black);
  static TextStyle  mediumWhiteText =  const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white);
  static TextStyle  bodyMediumWhiteText =  const TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.white);
  static TextStyle  bodyMediumGreyText =  const TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.grey);
  static TextStyle  largeBlackText =  const TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: Colors.black);
  static TextStyle  largeBoldBlackText =  const TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.black);
  static TextStyle  largeBoldGreyText =  const TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.grey);

  static ThemeData lightMode = ThemeData(

    scaffoldBackgroundColor: Colors.white,

    iconTheme: const IconThemeData(color: Colors.black),



    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontFamily: 'appFont',
      ),
      bodyLarge: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black,
        fontFamily: 'appFont',
      ),
      bodySmall: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,
        fontFamily: 'appFont',
      ),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black,
        fontFamily: 'appFont',
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange,
      primary: Colors.orange,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(Colors.orange),
        iconColor: const WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )
        ),
        textStyle: const WidgetStatePropertyAll(TextStyle(
          fontSize: 16,
          letterSpacing: .5,
          color: Colors.red,
          fontFamily: 'appFont',
        )),
        padding: const WidgetStatePropertyAll(EdgeInsets.only(
          left: 15,
          top: 0,
          bottom: 0,
          right: 15,
        )),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      hintStyle: const TextStyle(
        color: Color.fromRGBO(115, 119, 123, 1),
      ),
      fillColor: const Color.fromRGBO(248, 248, 248, 1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Color.fromRGBO(237, 239, 238, 1),
          width: .5,
        )
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Color.fromRGBO(237, 239, 238, 1),
          width: .5,
        )
      )
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,

      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,

      backgroundColor: Colors.white,
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
      ),

      selectedLabelStyle: TextStyle(
        fontSize: 12,
      ),
    ),

  );
}