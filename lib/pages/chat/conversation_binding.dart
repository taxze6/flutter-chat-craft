import 'package:get/get.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => ConversationBinding());
}
