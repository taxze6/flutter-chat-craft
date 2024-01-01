import 'package:flutter_chat_craft/pages/mine/mine_logic.dart';
import 'package:get/get.dart';

class MineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineLogic());
  }
}
