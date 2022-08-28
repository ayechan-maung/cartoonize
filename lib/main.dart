import 'package:cartoonize/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartoonize',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade200,
        primaryColor: Color(0xff023e8a),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xff023e8a)),
          titleTextStyle: TextStyle(color: Color(0xff023e8a), fontSize: 20, fontWeight: FontWeight.w600),
        ),
        buttonTheme: ButtonThemeData(buttonColor: Color(0xff023e8a)),
        iconTheme: IconThemeData(color: Color(0xff023e8a)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xff023e8a)),
      ),
      home: SplashScreen(),
    );
  }
}
