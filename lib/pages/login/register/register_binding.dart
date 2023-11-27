import 'package:flutter_chat_craft/pages/login/register/register_logic.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => RegisterLogic());
}
