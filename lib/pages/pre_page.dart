import 'package:cartoonize/pages/my_app.dart';
import 'package:cartoonize/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrePage extends StatefulWidget {
  const PrePage({Key? key}) : super(key: key);

  @override
  State<PrePage> createState() => _PrePageState();
}

class _PrePageState extends State<PrePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: MyApp(),
    );
  }
}
