import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../routes/app_navigator.dart';

enum SendVerificationCodeState {
  notSent, //The verification code has expired.
  wait, //Waiting for the user to enter the verification code.
}

class CheckCodeLogic extends GetxController {
  late String name;
  late String email;
  late CheckCodeMethod checkCodeMethod;
  late Function() regainVerifyCode;
  late int countDown;
  late Timer countDownTimer;
  late StreamController<ErrorAnimationType> errorController;
  late TextEditingController pinTextEditingController;
  late SendVerificationCodeState sendVerificationCodeState;

  @override
  void onInit() {
    super.onInit();
    name = Get.arguments["name"];
    email = Get.arguments["email"];
    regainVerifyCode = Get.arguments["regainVerifyCode"];
    checkCodeMethod = Get.arguments["checkCodeMethod"];
    countDown = 60;
    countDownFunction();
    errorController = StreamController<ErrorAnimationType>();
    pinTextEditingController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    errorController.close();
    countDownTimer.cancel();
  }

  ///60-second countdown
  void countDownFunction() {
    sendVerificationCodeState = SendVerificationCodeState.wait;
    errorController = StreamController<ErrorAnimationType>();
    pinTextEditingController = TextEditingController();
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown == 0) {
        countDownTimer.cancel();
        countDown = 60;
        sendVerificationCodeState = SendVerificationCodeState.notSent;
      } else {
        sendVerificationCodeState = SendVerificationCodeState.wait;
        countDown--;
      }
      update();
    });
  }

  ///Verify Captcha
  void checkVerifyCode(value) async {
    //If the verification is successful, execute the passed-in function.
    bool isAgree = await checkCodeMethod(pinTextEditingController.text);
    //If the captcha is incorrect, enable the error animation and clear the captcha input field.
    if (isAgree) {
      countDownTimer.cancel();
      Get.toNamed(AppRoutes.invite, arguments: {'email': email, 'name': name});
    } else {
      shake();
    }
  }

  void shake() {
    errorController.add(ErrorAnimationType.shake);
    Future.delayed(const Duration(milliseconds: 1500), () {
      pinTextEditingController.clear();
    });
  }
}
