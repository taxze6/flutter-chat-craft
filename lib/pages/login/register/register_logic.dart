import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';
import '../../../common/global_data.dart';
import '../../../models/user_info.dart';
import '../../../res/strings.dart';
import '../../../routes/app_navigator.dart';
import '../../../utils/app_reg_exp.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/sp/data_persistence.dart';
import '../../../widget/loading_view.dart';
import '../../../widget/toast_utils.dart';

class RegisterLogic extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController rePassWordController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  FocusNode cPassWordFocusNode = FocusNode();
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
    userNameController.dispose();
    emailController.dispose();
    passWordController.dispose();
    rePassWordController.dispose();
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    passWordFocusNode.dispose();
    cPassWordFocusNode.dispose();
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
    userNameFocusNode.addListener(() {
      if (userNameFocusNode.hasFocus) {}
      update(["usernameInput"]);
    });
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {}
      update(["emailInput"]);
    });
    passWordFocusNode.addListener(() {
      if (passWordFocusNode.hasFocus) {
      } else {
        isShowPwd = true;
        isShowPwdBtn.value = false;
      }
      update(["passwordInput"]);
    });
    cPassWordFocusNode.addListener(() {
      if (cPassWordFocusNode.hasFocus) {
      } else {
        isShowCPwd = true;
        isShowCPwdBtn.value = false;
      }
      update(["confirmPasswordInput"]);
    });
    userNameController.addListener(() {
      listenRules();
    });
    emailController.addListener(() {
      listenRules();
    });
    passWordController.addListener(() {
      if (passWordController.text.isNotEmpty) {
        isShowPwdBtn.value = true;
      } else {
        isShowPwdBtn.value = false;
      }
      listenRules();
    });
    rePassWordController.addListener(() {
      if (rePassWordController.text.isNotEmpty) {
        isShowCPwdBtn.value = true;
      } else {
        isShowCPwdBtn.value = false;
      }
      listenRules();
    });
  }

  void listenRules() {
    if (userNameController.text.length > 3 &&
        AppRegExp.emailRegExp.hasMatch(emailController.text) &&
        passWordController.text.length > 8 &&
        rePassWordController.text == passWordController.text &&
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
      var password = await AppUtils.encodeString(passWordController.text);
      var repassword = await AppUtils.encodeString(rePassWordController.text);
      var data = await LoadingView.singleton.wrap(
          asyncFunction: () => Apis.register(
                name: userNameController.text,
                email: emailController.text,
                password: password,
                repassword: repassword,
              ));
      if (data == false) {
        ToastUtils.toastText(StrRes.sendCodeError);
      } else {
        ToastUtils.toastText(StrRes.sendCodeSuccess);
        await AppNavigator.startCheckCode(
          name:userNameController.text,
          email: emailController.text,
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
    var password = await AppUtils.encodeString(passWordController.text);
    var repassword = await AppUtils.encodeString(rePassWordController.text);
    var data = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.register(
        name: userNameController.text,
        email: emailController.text,
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
    var password = await AppUtils.encodeString(passWordController.text);
    print(password);
    var data = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.checkRegisterEmailCode(
        name: userNameController.text,
        email: emailController.text,
        password: password,
        code: code,
      ),
    );
    if (data == false) {
      ToastUtils.toastText(StrRes.checkCodeError);
      return false;
    } else {
      String token = data["token"];
      await DataPersistence.putToken(token);
      UserInfo res = UserInfo.fromJson(data["user"]);
      await DataPersistence.putUserInfo(res);
      GlobalData.userInfo = res;
      GlobalData.token = token;
      ToastUtils.toastText(StrRes.checkCodeSuccess);
      ToastUtils.toastText(StrRes.loginSuccess);
      toHome();
      return true;
    }
  }

  void toHome() => AppNavigator.startHome();
}
