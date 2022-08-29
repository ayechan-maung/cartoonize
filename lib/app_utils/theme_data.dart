import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  String fontFamily = 'OpenSans';
  ThemeData lightTheme() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade200,
        primaryColor: Color(0xff023e8a),
        fontFamily: fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xff023e8a)),
          titleTextStyle: TextStyle(
            color: Color(0xff023e8a),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          titleLarge: TextStyle(color: Color(0xff023e8a)),
        ),
        buttonTheme: ButtonThemeData(buttonColor: Color(0xff023e8a)),
        iconTheme: IconThemeData(color: Color(0xff023e8a)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xff023e8a)),
        bottomAppBarColor: Colors.grey.shade200);
  }

  var scaffoldColor = Color(0xff243447);
  var dividerColor = Color(0xff2d445b);
  var cardColor = Color(0xff141d26);
  ThemeData darkTheme() {
    return ThemeData(
      popupMenuTheme: PopupMenuThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      appBarTheme: AppBarTheme(
        // brightness: Brightness.dark,
        color: scaffoldColor,
        titleTextStyle: TextStyle(fontSize: 17, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      fontFamily: fontFamily,
      scaffoldBackgroundColor: scaffoldColor,

      primaryColor: Color(0xff023e8a),
      // AppBar and Icon
      canvasColor: cardColor,
      cardColor: cardColor,
      // cardColor: Color(0xff2d132c),
      indicatorColor: Color(0xFFFFFFee),
      // dividerColor: Colors.grey.shade300,
      dividerColor: dividerColor,
      //Color(0xFF35343a),
      brightness: Brightness.dark,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
      bottomAppBarColor: scaffoldColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
      ),
      unselectedWidgetColor: Colors.white,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        buttonColor: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      primaryIconTheme: IconThemeData(color: Colors.white),
      hintColor: Color(0xff747d8c),
      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Color(0xff747d8c),
        ),
      ),
      dialogBackgroundColor: Color(0xff1e272e),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.grey.shade300),
      cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Colors.white,
          primaryContrastingColor: Colors.white,
          textTheme: CupertinoTextThemeData(
            actionTextStyle: TextStyle(
              inherit: false,
              color: Colors.white,
            ),
            navLargeTitleTextStyle: TextStyle(
              inherit: false,
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            primaryColor: Colors.white,
            navTitleTextStyle: TextStyle(
              inherit: false,
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          scaffoldBackgroundColor: Colors.grey.shade200,
          barBackgroundColor: cardColor,
          brightness: Brightness.dark),
      // accentIconTheme: IconThemeData(color: Colors.white),
    );
  }
}
