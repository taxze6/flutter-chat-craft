import 'package:flutter_chat_craft/pages/common/check_code/check_code_logic.dart';
import 'package:get/get.dart';

class CheckCodeBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => CheckCodeLogic());
}
