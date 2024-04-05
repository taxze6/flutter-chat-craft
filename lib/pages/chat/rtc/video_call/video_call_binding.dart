import 'package:flutter_chat_craft/pages/chat/rtc/video_call/video_call_logic.dart';
import 'package:get/get.dart';

class VideoCallBinding extends Bindings{
  @override
  void dependencies() => Get.lazyPut(() => VideoCallLogic());
}