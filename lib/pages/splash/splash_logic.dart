import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
import 'package:flutter_chat_craft/utils/file_util.dart';
import 'package:flutter_chat_craft/utils/sp/data_persistence.dart';
import 'package:get/get.dart';

class SplashLogic extends GetxController {
  void enterChatCraft() async {
    String emojiCachePath = await FileUtil.getEmojiCachePath();
    FileUtil.isFileCompleteBySize(
      emojiCachePath,
      5.27,
    ).then((value) {
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
        Get.dialog(
          AlertDialog(
            title: Text(StrRes.loseEmojiFile),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(StrRes.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  FileUtil.downloadEmoji().then((value) async {
                    if (value) {
                      Get.back();
                      String emojiCachePath =
                          await FileUtil.getEmojiCachePath();
                      FileUtil.extractZipFile(emojiCachePath);
                    } else {}
                  });
                },
                child: Text(StrRes.confirm),
              ),
            ],
          ),
        );
      }
    });
  }
}
