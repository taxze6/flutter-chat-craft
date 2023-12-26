import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/login/login_email/login_email_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/strings.dart';
import '../../../utils/touch_close_keyboard.dart';
import '../widget/login_universal_widget.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({Key? key}) : super(key: key);

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final emailLogic = Get.find<LoginEmailLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: loginAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(
                title: StrRes.loginWithEmail,
                content: StrRes.loginContent,
              ),
              SizedBox(
                height: 10.w,
              ),
              titleText(
                title: StrRes.email,
              ),
              SizedBox(
                height: 14.w,
              ),
              GetBuilder<LoginEmailLogic>(
                id: "emailInput",
                builder: (logic) => loginInput(
                  controller: logic.emailController,
                  focusNode: logic.emailFocusNode,
                  hintText: StrRes.emailInputHintText,
                ),
              ),
              SizedBox(
                height: 22.w,
              ),
              Obx(
                () => loginButton(
                    text: StrRes.sendCode,
                    onTap: emailLogic.sendCode,
                    isClick: emailLogic.isClick.value),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
