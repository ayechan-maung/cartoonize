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

  Future<PermissionStatus> contactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;

    if (permission.isDenied || permission.isPermanentlyDenied) {
      permission = await Permission.contacts.request();
      return permission;
    } else {
      return permission;
    }
  }

  // void handleInvalidPermissions(PermissionStatus permissionStatus) {
  //   if (permissionStatus == PermissionStatus.denied) {
  //     AppUtils.showSnackBar('Access to contact data denied', color: Colors.amber, textColor: Colors.black);
  //   } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
  //     AppUtils.showSnackBar('Contact data not available on device', color: Colors.amber, textColor: Colors.black);
  //     openAppSettings();
  //   }
  // }
}
