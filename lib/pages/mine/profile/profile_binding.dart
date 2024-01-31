import 'package:get/get.dart';

import 'profile_logic.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileLogic());
  }
}
