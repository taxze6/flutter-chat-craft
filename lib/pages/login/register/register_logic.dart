import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';
import '../../../models/user_info.dart';
import '../../../res/strings.dart';
import '../../../routes/app_navigator.dart';
import '../../../utils/app_reg_exp.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/sp/data_persistence.dart';
import '../../../widget/loading_view.dart';
import '../../../widget/toast_utils.dart';

class RegisterLogic extends GetxController {
  TextEditingController userNameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passWordCtr = TextEditingController();
  TextEditingController rePassWordCtr = TextEditingController();
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

  @override
  void onClose() {
    super.onClose();
    userNameCtr.dispose();
    emailCtr.dispose();
    passWordCtr.dispose();
    rePassWordCtr.dispose();
    userNameFn.dispose();
    emailFn.dispose();
    passWordFn.dispose();
    cPassWordFn.dispose();
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
    userNameCtr.addListener(() {
      listenRules();
    });
    emailCtr.addListener(() {
      listenRules();
    });
    passWordCtr.addListener(() {
      if (passWordCtr.text.isNotEmpty) {
        isShowPwdBtn.value = true;
      } else {
        isShowPwdBtn.value = false;
      }
      listenRules();
    });
    rePassWordCtr.addListener(() {
      if (rePassWordCtr.text.isNotEmpty) {
        isShowCPwdBtn.value = true;
      } else {
        isShowCPwdBtn.value = false;
      }
      listenRules();
    });
  }

  void listenRules() {
    if (userNameCtr.text.length > 3 &&
        AppRegExp.emailRegExp.hasMatch(emailCtr.text) &&
        passWordCtr.text.length > 8 &&
        rePassWordCtr.text == passWordCtr.text &&
        isAgreeTerms.value) {
      isClick.value = true;
    } else {
      isClick.value = false;
    }
  }

  void agreeTerms() {
    isAgreeTerms.value = !isAgreeTerms.value;
    listenRules();
  }

  Future<bool> register() async {
    if (isClick.value) {
      var password = await AppUtils.encodeString(passWordCtr.text);
      var repassword = await AppUtils.encodeString(rePassWordCtr.text);
      var data = await LoadingView.singleton.wrap(
          asyncFunction: () => Apis.register(
                name: userNameCtr.text,
                email: emailCtr.text,
                password: password,
                repassword: repassword,
              ));
      if (data == false) {
        ToastUtils.toastText(StrRes.sendCodeError);
      } else {
        ToastUtils.toastText(StrRes.sendCodeSuccess);
        await AppNavigator.startCheckCode(
          email: emailCtr.text,
          checkCodeMethod: checkCodeMethod,
          regainVerifyCode: regainVerifyCode,
        );
      }
      return true;
    } else {
      ToastUtils.toastText(StrRes.inputEmptyReminder);
      return false;
    }
  }

  ///Resend verification code
  Future<bool> regainVerifyCode() async {
    var password = await AppUtils.encodeString(passWordCtr.text);
    var repassword = await AppUtils.encodeString(rePassWordCtr.text);
    var data = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.register(
        name: userNameCtr.text,
        email: emailCtr.text,
        password: password,
        repassword: repassword,
      ),
    );
    if (data == false) {
      ToastUtils.toastText(StrRes.sendCodeError);
      return false;
    } else {
      ToastUtils.toastText(StrRes.sendCodeSuccess);
      return true;
    }
  }

  Future<bool> checkCodeMethod(String code) async {
    var data = await LoadingView.singleton.wrap(
      asyncFunction: () =>
          Apis.checkRegisterEmailCode(email: emailCtr.text, code: code),
    );
    if (data == false) {
      ToastUtils.toastText(StrRes.checkCodeError);
      return false;
    } else {
      String token = data["token"];
      await DataPersistence.putToken(token);
      UserInfo res = UserInfo.fromJson(data["user"]);
      await DataPersistence.putUserInfo(res);
      ToastUtils.toastText(StrRes.checkCodeSuccess);
      ToastUtils.toastText(StrRes.loginSuccess);
      toHome();
      return true;
    }
  }

  void toHome() => AppNavigator.startHome();
}
