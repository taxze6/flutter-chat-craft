import 'package:flutter_chat_craft/pages/chat/conversation_logic.dart';
import 'package:flutter_chat_craft/pages/home/home_logic.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => ConversationLogic());
  }
}
