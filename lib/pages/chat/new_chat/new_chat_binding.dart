import 'package:flutter_chat_craft/pages/chat/new_chat/new_chat_logic.dart';
import 'package:get/get.dart';

class NewChatBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => NewChatLogic());
}
