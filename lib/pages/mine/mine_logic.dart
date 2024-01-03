import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:get/get.dart';

import '../../models/user_info.dart';
import '../../routes/app_navigator.dart';

class MineLogic extends GetxController {
  late UserInfo userInfo;

  void setUserInfo(UserInfo info) {
    userInfo = info;
    update();
  }

  bool get isSelf => userInfo.userID == GlobalData.userInfo.userID;

  void toChat() {
    AppNavigator.startChat(userInfo: userInfo);
  }
}
