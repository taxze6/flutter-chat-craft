import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterLogic extends GetxController {
  TextEditingController userNameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passWordCtr = TextEditingController();
  TextEditingController cPassWordCtr = TextEditingController();
  FocusNode userNameFn = FocusNode();
  FocusNode emailFn = FocusNode();
  FocusNode passWordFn = FocusNode();
  FocusNode cPassWordFn = FocusNode();
  bool isShowPwd = true;
  bool isShowCPwd = true;
  Rx<bool> isShowPwdBtn = false.obs;
  Rx<bool> isShowCPwdBtn = false.obs;
  Rx<bool> isAgreeTerms = false.obs;
  Rx<bool> isClick = false.obs;

  @override
  void onInit() {
    super.onInit();
    listenFocus();
  }

  void isShowPwdFunc() {
    isShowPwd = !isShowPwd;
    update(["passwordInput"]);
  }

  void isShowCPwdFunc() {
    isShowCPwd = !isShowCPwd;
    update(["confirmPasswordInput"]);
  }

  void listenFocus() {
    userNameFn.addListener(() {
      if (userNameFn.hasFocus) {}
      update(["usernameInput"]);
    });
    emailFn.addListener(() {
      if (emailFn.hasFocus) {}
      update(["emailInput"]);
    });
    passWordFn.addListener(() {
      if (passWordFn.hasFocus) {
      } else {
        isShowPwd = true;
        isShowPwdBtn.value = false;
      }
      update(["passwordInput"]);
    });
    cPassWordFn.addListener(() {
      if (cPassWordFn.hasFocus) {
      } else {
        isShowCPwd = true;
        isShowCPwdBtn.value = false;
      }
      update(["confirmPasswordInput"]);
    });
    passWordCtr.addListener(() {
      if (passWordCtr.text.isNotEmpty) {
        isShowPwdBtn.value = true;
      } else {
        isShowPwdBtn.value = false;
      }
    });
    cPassWordCtr.addListener(() {
      if (cPassWordCtr.text.isNotEmpty) {
        isShowCPwdBtn.value = true;
      } else {
        isShowCPwdBtn.value = false;
      }
    });
  }

  void agreeTerms() {
    isAgreeTerms.value = !isAgreeTerms.value;
  }
}
