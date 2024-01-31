import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:get/get.dart';

class ProfileState {
  late UserInfo userInfo;

  ProfileState() {
    userInfo = Get.arguments['userInfo'];
  }
}
