import 'package:cartoonize/local_db/shared_pref.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  checkTheme() {
    SharedPref.getData(key: SharedPref.theme).then((value) {
      if (value != null) {
        if (value == "dark") {
          themeMode = ThemeMode.dark;
          notifyListeners();
        } else {
          themeMode = ThemeMode.light;
          notifyListeners();
        }
      }
    });
  }

  changeToDark() {
    SharedPref.setData(key: SharedPref.theme, value: "dark");
    themeMode = ThemeMode.dark;
    notifyListeners();
  }

  changeToLight() {
    SharedPref.setData(key: SharedPref.theme, value: "light");
    themeMode = ThemeMode.light;
    notifyListeners();
  }
}
