import 'package:package_info_plus/package_info_plus.dart';

class AppUtils {
  static getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    print(packageInfo.version);
  }
}
