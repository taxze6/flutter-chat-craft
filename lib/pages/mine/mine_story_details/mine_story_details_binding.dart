import 'package:flutter_chat_craft/pages/mine/mine_story_details/mine_story_details_logic.dart';
import 'package:get/get.dart';

class MineStoryDetailsBindings extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => MineStoryDetailsLogic());
}
