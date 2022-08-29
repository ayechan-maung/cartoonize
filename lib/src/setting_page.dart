import 'package:cartoonize/app_utils/app_util.dart';
import 'package:cartoonize/provider/theme_provider.dart';
import 'package:cartoonize/src/widget/card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingPage extends HookWidget {
  bool isLight = false;

  AppUtils appUtils = AppUtils();

  getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    versionNumber.value = packageInfo.version;
  }

  var versionNumber;

  @override
  Widget build(BuildContext context) {
    versionNumber = useState('');

    useEffect(() {
      getAppInfo();

      return () {};
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: Column(children: [
        CardItem(
          pv: 0,
          child: ListTile(
              title: Text('Theme'),
              trailing: Consumer<ThemeProvider>(builder: (context, tp, child) {
                return DropdownButton(
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    DropdownMenuItem(
                      child: Text("Light"),
                      value: ThemeMode.light,
                    ),
                    DropdownMenuItem(child: Text("Dark"), value: ThemeMode.dark),
                  ],
                  onChanged: (dynamic value) {
                    if (value == ThemeMode.light) {
                      tp.changeToLight();
                    } else {
                      tp.changeToDark();
                    }
                  },
                  value: tp.themeMode,
                  underline: Container(),
                );
              })),
        ),
        CardItem(pv: 0, child: ListTile(title: Text('About'), trailing: Text(versionNumber.value))),
        CardItem(pv: 0, child: ListTile(title: Text('Language'), trailing: Text('English')))
      ]),
    );
  }
}
