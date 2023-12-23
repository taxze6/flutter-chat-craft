import 'package:flutter_chat_craft/pages/chat/chat/chat_logic.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => ChatLogic());
}
