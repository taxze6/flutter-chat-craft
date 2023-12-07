import 'package:dio/dio.dart';

import '../models/user_info.dart';
import '../utils/http_util.dart';
import '../utils/sp/data_persistence.dart';
import 'urls.dart';

String token = DataPersistence.getToken();

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
    UserInfo res = DataPersistence.getUserInfo();
    var data = await HttpUtil.post(Urls.findUserWithName,
        options: Options(
          headers: {
            "Authorization": token,
            "UserId": res.userID,
          },
          contentType: 'application/json',
        ),
        data: {"name": name});
    if (data == null) {
      return false;
    }
    return data;
  }

  static Future<dynamic> searchAddFriendWithUserName({
    String targetName = "",
  }) async {
    UserInfo res = DataPersistence.getUserInfo();
    var data = await HttpUtil.post(Urls.searchAddFriendWithUserName,
        options: Options(
          headers: {
            "Authorization": token,
            "UserId": res.userID,
          },
          contentType: 'application/json',
        ),
        data: {"targetName": targetName});
    if (data == null) {
      return false;
    }
    return data;
  }
}
