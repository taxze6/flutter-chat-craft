import 'package:get/get.dart';

import 'invite_logic.dart';

class InviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteLogic());
  }
}
