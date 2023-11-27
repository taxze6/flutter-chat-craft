import 'package:flutter_chat_craft/pages/login/login_email/login_email_logic.dart';
import 'package:get/get.dart';

class LoginEmailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => LoginEmailLogic());
}
