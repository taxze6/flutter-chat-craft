import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
import 'package:flutter_chat_craft/utils/file_util.dart';
import 'package:flutter_chat_craft/utils/sp/data_persistence.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import 'package:get/get.dart';

class SplashLogic extends GetxController {
  void enterChatCraft() async {
    String emojiCachePath = await FileUtil.getEmojiCachePath();
    FileUtil.isFileCompleteBySize(emojiCachePath, 20).then((value) {
      if (value) {
        String token = DataPersistence.getToken();
        if (token == '') {
          AppNavigator.startLogin();
        } else {
          UserInfo user = DataPersistence.getUserInfo();
          GlobalData.userInfo = user;
          GlobalData.token = token;
          AppNavigator.startHome();
        }
      } else {
        //System file loss.
        ToastUtils.toastText("");
        FileUtil.downloadEmoji();
      }
    });
  }
}
