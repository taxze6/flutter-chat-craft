import 'dart:io';

import 'package:crypto/crypto.dart';
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

  Future<bool> checkLocalFile(String filePath) async {
    //Check whether the App resource is complete.
    if (!File(filePath).existsSync()) {
      print('File does not exist');
      return false;
    }

    // Get file size
    File file = File(filePath);
    int fileSize = await file.length();

    print('File integrity');
    return true;
  }

  ///Compare file sizes
  Future<bool> isFileCompleteBySize(String filePath, int expectedSize) async {
    File file = File(filePath);
    int fileSize = await file.length();
    if (fileSize == expectedSize) {
      print('File integrity');
      return true;
    } else {
      print('Incomplete file');
      return false;
    }
  }

  Future<bool> isFileCompleteByHash(String filePath, String expectedHash) async {
    File file = File(filePath);
    List<int> fileBytes = await file.readAsBytes();

    // Calculates the hash value of the file
    String fileHash = md5.convert(fileBytes).toString();

    if (fileHash == expectedHash) {
      print('File integrity');
      return true;
    } else {
      print('Incomplete file');
      return false;
    }
  }
}
