import 'package:get/get.dart';

import '../../models/user_info.dart';

class MineLogic extends GetxController {
  late UserInfo userInfo;

  void setUserInfo(UserInfo info) {
    userInfo = info;
    update();
  }
}
