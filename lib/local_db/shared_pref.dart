import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const theme = "theme";

  static Future<bool> setData(
      {required String key, required String value}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString(key, value);
    return true;
  }

  static Future<String?> getData({required String key}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? s = shared.getString(key);
    return s;
  }
}
