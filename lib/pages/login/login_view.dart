import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../res/images.dart';
import '../../utils/touch_close_keyboard.dart';
import 'login_logic.dart';
import 'widget/login_universal_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginLogic = Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: loginAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.w),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              titleText(
                title: StrRes.login,
                content: StrRes.loginContent,
              ),
              SizedBox(
                height: 10.w,
              ),
              titleText(
                title: StrRes.username,
              ),
              SizedBox(
                height: 13.w,
              ),
              GetBuilder<LoginLogic>(
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
                title: StrRes.password,
              ),
              SizedBox(
                height: 10.w,
              ),
              GetBuilder<LoginLogic>(
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
                height: 14.w,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => loginLogic.forgetPassword,
                  child: Text(
                    StrRes.forgetPassword,
                    style: TextStyle(
                      fontSize: 12.sp
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.w,
              ),
              loginButton(
                  text: StrRes.loginContinue, onTap: () {}, isClick: false),
            ]),
          ),
        ),
      ),
    );
  }
}
