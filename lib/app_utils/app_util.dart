import 'package:flutter/material.dart';

class AppUtils {
  static dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog();
        });
  }
}
