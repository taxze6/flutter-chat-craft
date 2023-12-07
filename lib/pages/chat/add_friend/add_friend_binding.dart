import 'package:flutter_chat_craft/pages/chat/add_friend/add_friend_logic.dart';
import 'package:get/get.dart';

class AddFriendBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => AddFriendLogic());
}
