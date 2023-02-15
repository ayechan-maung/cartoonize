// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cartoonize/pages/my_app.dart';
import 'package:cartoonize/pages/splash_screen.dart';
import 'package:cartoonize/provider/theme_provider.dart';
import 'package:cartoonize/src/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cartoonize/main.dart';

void main() {
  testWidgets('Cartoonize widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
        await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ThemeProvider())
      ],
      child: MaterialApp(home: SplashScreen())));
    });
    
  });

  testWidgets('Cartoonize Root', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
        await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ThemeProvider())
      ],
      child: MaterialApp(home: RootPage())));
    });
    
  });
}
