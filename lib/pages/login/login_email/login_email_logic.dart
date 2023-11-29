import 'package:flutter/material.dart';
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
      }
      return false;
    } else {
      ToastUtils.toastText(StrRes.inputEmptyReminder);
      return false;
    }
  }
}
