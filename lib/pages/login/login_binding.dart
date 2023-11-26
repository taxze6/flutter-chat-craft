import 'package:flutter_chat_craft/pages/login/login_logic.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(()=>LoginLogic());
}
