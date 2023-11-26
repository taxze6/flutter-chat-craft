import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  TextEditingController userNameCtr = TextEditingController();
  TextEditingController passWordCtr = TextEditingController();
  FocusNode userNameFn = FocusNode();
  FocusNode passWordFn = FocusNode();
  bool isShowPwd = true;
  Rx<bool> isShowPwdBtn = false.obs;

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
}
