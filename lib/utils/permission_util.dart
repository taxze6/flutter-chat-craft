import 'package:permission_handler/permission_handler.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  PermissionUtil._();

  static void camera(Function() onGranted) async {
    if (await p.Permission.camera.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted();
    }
    if (await p.Permission.camera.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void storage(Function() onGranted) async {
    if (await p.Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted();
    }
    if (await p.Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void microphone(Function() onGranted) async {
    if (await p.Permission.microphone.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted();
    }
    if (await p.Permission.microphone.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void location(Function() onGranted) async {
    if (await p.Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted();
    }
    if (await p.Permission.location.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void speech(Function() onGranted) async {
    if (await p.Permission.speech.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted();
    }
    if (await p.Permission.speech.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void photos(Function() onGranted) async {
    if (await p.Permission.photos.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted();
    }
    if (await p.Permission.photos.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static Future<Map<Permission, PermissionStatus>> request(
      List<Permission> permissions) async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }
}
