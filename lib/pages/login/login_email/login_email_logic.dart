import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_reg_exp.dart';

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
}
