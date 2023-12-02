import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/login/register/register_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/images.dart';
import '../../../res/strings.dart';
import '../../../utils/touch_close_keyboard.dart';
import '../../../widget/my_check_box.dart';
import '../widget/login_universal_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registerLogic = Get.find<RegisterLogic>();

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
                    title: StrRes.createAccount,
                    content: StrRes.loginContent,
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  titleText(
                    title: StrRes.username,
                    content: StrRes.usernameRegistrationRules,
                  ),
                  SizedBox(
                    height: 13.w,
                  ),
                  GetBuilder<RegisterLogic>(
                    id: "usernameInput",
                    builder: (logic) => loginInput(
                      controller: logic.userNameCtr,
                      focusNode: logic.userNameFn,
                      hintText: StrRes.usernameInputHintText,
                    ),
                  ),
                  SizedBox(
                    height: 16.w,
                  ),
                  titleText(
                    title: StrRes.email,
                  ),
                  SizedBox(
                    height: 13.w,
                  ),
                  GetBuilder<RegisterLogic>(
                    id: "emailInput",
                    builder: (logic) => loginInput(
                      controller: logic.emailCtr,
                      focusNode: logic.emailFn,
                      hintText: StrRes.emailInputHintText,
                    ),
                  ),
                  SizedBox(
                    height: 16.w,
                  ),
                  titleText(
                    title: StrRes.password,
                    content: StrRes.passwordRegistrationRules,
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  GetBuilder<RegisterLogic>(
                    id: "passwordInput",
                    builder: (logic) {
                      return Stack(
                        children: [
                          loginInput(
                            controller: logic.passWordCtr,
                            focusNode: logic.passWordFn,
                            hintText: StrRes.passwordInputHintText,
                            obscureText: logic.isShowPwd,
                          ),
                          Positioned(
                            right: 12.w,
                            bottom: 0.0,
                            top: 0.0,
                            child: Obx(
                              () => Visibility(
                                visible: logic.isShowPwdBtn.value,
                                child: GestureDetector(
                                  onTap: logic.isShowPwdFunc,
                                  behavior: HitTestBehavior.translucent,
                                  child: SvgPicture.asset(
                                    logic.isShowPwd
                                        ? ImagesRes.icNotShowPwd
                                        : ImagesRes.icShowPwd,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 16.w,
                  ),
                  titleText(
                    title: StrRes.confirmPassword,
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  GetBuilder<RegisterLogic>(
                    id: "confirmPasswordInput",
                    builder: (logic) {
                      return Stack(
                        children: [
                          loginInput(
                            controller: logic.rePassWordCtr,
                            focusNode: logic.cPassWordFn,
                            hintText: StrRes.confirmPasswordInputHintText,
                            obscureText: logic.isShowCPwd,
                          ),
                          Positioned(
                            right: 12.w,
                            bottom: 0.0,
                            top: 0.0,
                            child: Obx(
                              () => Visibility(
                                visible: logic.isShowCPwdBtn.value,
                                child: GestureDetector(
                                  onTap: logic.isShowCPwdFunc,
                                  behavior: HitTestBehavior.translucent,
                                  child: SvgPicture.asset(
                                    logic.isShowCPwd
                                        ? ImagesRes.icNotShowPwd
                                        : ImagesRes.icShowPwd,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 16.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          child: Obx(
                            () => MyCheckBox(
                              isCheck: registerLogic.isAgreeTerms.value,
                              onTap: () => registerLogic.agreeTerms(),
                            ),
                          )),
                      SizedBox(
                        width: 8.w,
                      ),
                      Expanded(
                        child: Text(
                          StrRes.termsService,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18.w,
                  ),
                  Obx(
                    () => loginButton(
                        text: StrRes.register,
                        onTap: () => registerLogic.register(),
                        isClick: registerLogic.isClick.value),
                  ),
                  SizedBox(
                    height: 14.w,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: StrRes.haveAccount,
                            style: const TextStyle(
                              color: Color(0xFF707070),
                            ),
                          ),
                          TextSpan(
                            text: " ${StrRes.login}",
                            style: const TextStyle(
                              color: Color(0xFFFCC604),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
