import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_chat_craft/common/global_data.dart';

import '../models/user_info.dart';
import '../utils/http_util.dart';
import '../utils/sp/data_persistence.dart';
import 'urls.dart';

class Apis {
  /// login
  static Future<dynamic> login({
    String username = "",
    String password = "",
  }) async {
    var data = await HttpUtil.post(Urls.login,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          "name": username,
          "password": password,
        });
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> loginEmail({
    String email = "",
  }) async {
    var data = await HttpUtil.post(Urls.emailLogin,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          "email": email,
        });
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> checkLoginEmailCode({
    String email = "",
    String code = "",
  }) async {
    var data = await HttpUtil.post(Urls.emailLoginCodeCheck,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          "email": email,
          "code": code,
        });
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> register({
    String name = "",
    String email = "",
    String password = "",
    String repassword = "",
  }) async {
    var data = await HttpUtil.post(Urls.register,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          "name": name,
          "email": email,
          "password": password,
          "repassword": repassword
        });
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> checkRegisterEmailCode({
    String name = "",
    String email = "",
    String password = "",
    String code = "",
  }) async {
    var data = await HttpUtil.post(Urls.emailRegisterCodeCheck,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          "name": name,
          "email": email,
          "password": password,
          "code": code,
        });
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> findWithUserName({
    String name = "",
  }) async {
    var data = await HttpUtil.post(Urls.findUserWithName,
        options: Options(
          headers: {
            "Authorization": GlobalData.token,
            "UserId": GlobalData.userInfo.userID,
          },
          contentType: 'application/json',
        ),
        data: {"name": name});
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> addFriendWithUserName({
    String targetName = "",
  }) async {
    var data = await HttpUtil.post(Urls.addFriendWithUserName,
        options: Options(
          headers: {
            "Authorization": GlobalData.token,
            "UserId": GlobalData.userInfo.userID,
          },
          contentType: 'application/json',
        ),
        data: {"targetName": targetName});
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> getFriends() async {
    var data = await HttpUtil.post(
      Urls.loadFriends,
      options: Options(
        headers: {
          "Authorization": GlobalData.token,
          "UserId": GlobalData.userInfo.userID,
        },
        contentType: 'application/json',
      ),
      data: {},
    );
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> getRedisMsg({
    required int targetId,
    required int start,
    required int end,
    required bool isRev,
  }) async {
    var data = await HttpUtil.post(Urls.getRedisMsg,
        options: Options(
          headers: {
            "Authorization": GlobalData.token,
            "UserId": GlobalData.userInfo.userID,
          },
          contentType: 'application/json',
        ),
        data: {
          "targetId": targetId,
          "start": start,
          "end": end,
          "isRev": isRev,
        });
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> uploadImage({
    required String imagePath,
    required String imageFileName,
    required Function(int sent, int total) onSendProgress,
  }) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imagePath, filename: imageFileName),
    });
    var data = await HttpUtil.post(
      Urls.uploadImage,
      options: Options(
        headers: {
          "Authorization": GlobalData.token,
          "UserId": GlobalData.userInfo.userID,
        },
        contentType: 'application/json',
      ),
      data: formData,
      onSendProgress: onSendProgress,
    );
    if (data == null) {
      return false;
    }
    return data;
  }
}
