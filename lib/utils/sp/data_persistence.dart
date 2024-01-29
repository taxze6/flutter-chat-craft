import 'package:flutter_chat_craft/models/user_info.dart';

import 'sp_util.dart';

class DataPersistence {
  static const _language = "language";
  static const _token = "token";
  static const _user = "user";

  static Future<bool>? putLanguage(int index) {
    return SpUtil.putInt(_language, index);
  }

  static int? getLanguage() {
    return SpUtil.getInt(_language);
  }

  static Future<bool>? putToken(String token) {
    return SpUtil.putString(_token, token);
  }

  static String getToken() {
    return SpUtil.getString(_token) ?? "";
  }

  static Future<bool>? removeToken() {
    return SpUtil.remove(_token);
  }

  static Future<bool>? putUserInfo(UserInfo user) {
    return SpUtil.putObject(_user, user);
  }

  static UserInfo getUserInfo() {
    return UserInfo.fromJson(SpUtil.getObject(_user)!.cast<String, dynamic>());
  }

  static Future<bool>? removeUser() {
    return SpUtil.remove(_user);
  }
}
