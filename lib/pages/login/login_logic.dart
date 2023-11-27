import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/app_navigator.dart';

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
        if (passWordCtr.text.length >= 6 && userNameCtr.text.length >= 2) {
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

  void forgetPassword() {}

  void loginEmail() => AppNavigator.startLoginEmail();

  void register() => AppNavigator.startRegister();
}
