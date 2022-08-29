import 'package:permission_handler/permission_handler.dart';

class OwnPermissionHandler {
  Future<bool> cameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.camera.request();
    }

    if (status.isRestricted) {
      await Future.delayed(Duration(seconds: 3));
      openAppSettings();
      return false;
    }

    if (!status.isGranted) {
      return false;
    }
    return true;
  }

  Future<bool> storagePermission() async {
    var status = await Permission.storage.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.storage.request();
    }

    if (status.isRestricted) {
      await Future.delayed(Duration(seconds: 3));
      openAppSettings();
      return false;
    }

    if (!status.isGranted) {
      return false;
    }
    return true;
  }
}
