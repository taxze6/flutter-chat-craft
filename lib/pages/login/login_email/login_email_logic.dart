import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';
import '../../../models/user_info.dart';
import '../../../res/strings.dart';
import '../../../utils/app_reg_exp.dart';
import '../../../utils/sp/data_persistence.dart';
import '../../../widget/loading_view.dart';
import '../../../widget/toast_utils.dart';

class LoginEmailLogic extends GetxController {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  Rx<bool> isClick = false.obs;

  @override
  void onInit() {
    super.onInit();
    listenFocus();
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    emailFocusNode.dispose();
  }

  void listenFocus() {
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {}
      update(["emailInput"]);
    });
    emailController.addListener(() {
      if (AppRegExp.emailRegExp.hasMatch(emailController.text)) {
        isClick.value = true;
      } else {
        isClick.value = false;
      }
    });
  }

  Future<bool> sendCode() async {
    if (isClick.value) {
      var data = await LoadingView.singleton.wrap(asyncFunction: () => Apis.loginEmail(email: emailController.text));
      if (data == false) {
        ToastUtils.toastText(StrRes.sendCodeError);
      } else {
        ToastUtils.toastText(StrRes.sendCodeSuccess);
        await AppNavigator.startCheckCode(
          name: '匿名', //todo 这里不知道传啥，看下
          email: emailController.text,
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
      asyncFunction: () => Apis.loginEmail(email: emailController.text),
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
    var data = await LoadingView.singleton.wrap(asyncFunction: () => Apis.checkLoginEmailCode(email: emailController.text, code: code));
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
