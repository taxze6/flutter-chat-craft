import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
import 'package:flutter_chat_craft/utils/sp/data_persistence.dart';
import 'package:get/get.dart';

class SplashLogic extends GetxController {
  void enterChatCraft() {
    String token = DataPersistence.getToken();
    if (token == '') {
      AppNavigator.startLogin();
    } else {
      UserInfo user = DataPersistence.getUserInfo();
      GlobalData.userInfo = user;
      GlobalData.token = token;
      AppNavigator.startHome();
    }
  }

  Future<bool> checkLocalFile() async {
    return false;
  }
}
