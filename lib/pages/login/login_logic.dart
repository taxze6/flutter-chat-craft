import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/utils/sp/data_persistence.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import 'package:get/get.dart';

import '../../common/apis.dart';
import '../../models/user_info.dart';
import '../../routes/app_navigator.dart';
import '../../utils/app_utils.dart';
import '../../widget/loading_view.dart';

class LoginLogic extends GetxController {
  TextEditingController userNameCtr = TextEditingController();
  TextEditingController passWordCtr = TextEditingController();
  FocusNode userNameFn = FocusNode();
  FocusNode passWordFn = FocusNode();
  bool isShowPwd = true;
  Rx<bool> isShowPwdBtn = false.obs;
  Rx<bool> isClick = false.obs;

  @override
  void onInit() {
    super.onReady();
    listenFocus();
    // printData();
  }

  void printData() {
    String token = DataPersistence.getToken();
    UserInfo res = DataPersistence.getUserInfo();
    print(token);
    print(res.toString());
  }

  @override
  void onClose() {
    super.onClose();
    userNameCtr.dispose();
    passWordCtr.dispose();
    userNameFn.dispose();
    passWordFn.dispose();
  }

  void listenFocus() {
    userNameFn.addListener(() {
      if (userNameFn.hasFocus) {}
      update(["usernameInput"]);
    });
    passWordFn.addListener(() {
      if (passWordFn.hasFocus) {
      } else {
        isShowPwd = true;
        isShowPwdBtn.value = false;
      }
      update(["passwordInput"]);
    });
    passWordCtr.addListener(() {
      if (passWordCtr.text.isNotEmpty) {
        isShowPwdBtn.value = true;
        if (passWordCtr.text.length > 8 && userNameCtr.text.length > 3) {
          isClick.value = true;
        } else {
          isClick.value = false;
        }
      } else {
        isShowPwdBtn.value = false;
      }
    });
  }

  void isShowPwdFunc() {
    isShowPwd = !isShowPwd;
    update(["passwordInput"]);
  }

  Future<bool> login() async {
    if (isClick.value) {
      var password = await AppUtils.encodeString(passWordCtr.text);
      var data = await LoadingView.singleton.wrap(
          asyncFunction: () => Apis.login(
                username: userNameCtr.text,
                password: password,
              ));
      if (data == false) {
        ToastUtils.toastText(StrRes.loginError);

        return false;
      } else {
        String token = data["token"];
        await DataPersistence.putToken(token);
        UserInfo res = UserInfo.fromJson(data["user"]);
        await DataPersistence.putUserInfo(res);
        GlobalData.userInfo = res;
        GlobalData.token = token;
        ToastUtils.toastText(StrRes.loginSuccess);
        return true;
      }
    } else {
      ToastUtils.toastText(StrRes.inputEmptyReminder);
      return false;
    }
  }

  void startLogin() async {
    bool isLogin = await login();
    if (isLogin) {
      toHome();
    } else {}
  }

  void forgetPassword() {}

  void loginEmail() => AppNavigator.startLoginEmail();

  void register() => AppNavigator.startRegister();

  void toHome() {
    AppNavigator.startHome();
  }
}
