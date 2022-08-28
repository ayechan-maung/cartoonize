import 'package:cartoonize/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        primaryColor: Color(0xff4A148C),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal),
          titleTextStyle: TextStyle(color: Color(0xff4A148C), fontSize: 20, fontWeight: FontWeight.w600),
        ),
        buttonTheme: ButtonThemeData(buttonColor: Color(0xff4A148C)),
        iconTheme: IconThemeData(color: Colors.teal),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xff90A4AE)),
      ),
      home: SplashScreen(),
    );
  }
}
