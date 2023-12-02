import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/urls.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';
import '../../../models/user_info.dart';
import '../../../res/strings.dart';
import '../../../utils/app_reg_exp.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/sp/data_persistence.dart';
import '../../../widget/loading_view.dart';
import '../../../widget/toast_utils.dart';

class LoginEmailLogic extends GetxController {
  TextEditingController emailCtr = TextEditingController();
  FocusNode emailFn = FocusNode();

  Rx<bool> isClick = false.obs;

  @override
  void onInit() {
    super.onInit();
    listenFocus();
  }

  @override
  void onClose() {
    super.onClose();
    emailCtr.dispose();
    emailFn.dispose();
  }

  void listenFocus() {
    emailFn.addListener(() {
      if (emailFn.hasFocus) {}
      update(["emailInput"]);
    });
    emailCtr.addListener(() {
      if (AppRegExp.emailRegExp.hasMatch(emailCtr.text)) {
        isClick.value = true;
      } else {
        isClick.value = false;
      }
    });
  }

  Future<bool> sendCode() async {
    if (isClick.value) {
      var data = await LoadingView.singleton
          .wrap(asyncFunction: () => Apis.loginEmail(email: emailCtr.text));
      if (data == false) {
        ToastUtils.toastText(StrRes.sendCodeError);
      } else {
        ToastUtils.toastText(StrRes.sendCodeSuccess);
        await AppNavigator.startCheckCode(
          email: emailCtr.text,
          regainVerifyCode: regainVerifyCode,
          checkCodeMethod: checkCodeMethod,
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
    var data = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.loginEmail(email: emailCtr.text),
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
            Apis.checkLoginEmailCode(email: emailCtr.text, code: code));
    if (data == false) {
      ToastUtils.toastText(StrRes.checkCodeError);
      return false;
    } else {
      String token = data["token"];
      await DataPersistence.putToken(token);
      UserInfo res = UserInfo.fromJson(data["user"]);
      await DataPersistence.putUserInfo(res);
      ToastUtils.toastText(StrRes.checkCodeSuccess);
      toHome();
      return true;
    }
  }

  void toHome() => AppNavigator.startHome();
}
