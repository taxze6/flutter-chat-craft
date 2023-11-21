import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/permission_util.dart';

class PermissionController extends GetxController {
  @override
  void onInit() async {
    Map<Permission, PermissionStatus> statuses = await PermissionUtil.request([
      Permission.camera,
      Permission.storage,
      Permission.microphone,
      Permission.speech,
      Permission.location,
      Permission.notification,
    ]);
    super.onInit();
  }
}
