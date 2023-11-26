import 'package:flutter_chat_craft/pages/splash/splash_logic.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(()=>SplashLogic());
}
