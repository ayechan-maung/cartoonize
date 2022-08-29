import 'package:cartoonize/app_utils/theme_data.dart';
import 'package:cartoonize/pages/splash_screen.dart';
import 'package:cartoonize/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeData appTheme = AppThemeData();

  @override
  void initState() {
    super.initState();
    ThemeProvider theme = Provider.of<ThemeProvider>(context, listen: false);
    theme.checkTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: ((context, tp, child) {
        return MaterialApp(
          title: 'Cartoonize',
          debugShowCheckedModeBanner: false,
          themeMode: tp.themeMode,
          theme: appTheme.lightTheme(),
          darkTheme: appTheme.darkTheme(),
          home: SplashScreen(),
        );
      }),
    );
  }
}
