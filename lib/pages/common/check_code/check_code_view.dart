import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/common/check_code/check_code_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../utils/touch_close_keyboard.dart';
import '../../login/widget/login_universal_widget.dart';

class CheckCodeView extends StatefulWidget {
  const CheckCodeView({Key? key}) : super(key: key);

  @override
  State<CheckCodeView> createState() => _CheckCodeViewState();
}

class _CheckCodeViewState extends State<CheckCodeView> {
  final logic = Get.find<CheckCodeLogic>();

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
                  title: StrRes.confirmYourNumber,
                  content: StrRes.confirmYourNumberHint,
                  contentImportant: logic.email,
                ),
                SizedBox(
                  height: 22.w,
                ),
                PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: const TextStyle(
                    color: PageStyle.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  // obscureText: false,
                  // obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  hintCharacter: '-',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFEBEBED),
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    fieldHeight: 41.w,
                    fieldWidth: 41.w,
                    borderWidth: 1,
                    activeColor: Colors.black,
                    selectedColor: PageStyle.mainColor,
                    inactiveColor: const Color(0xFFEBEBED),
                    disabledColor: const Color.fromRGBO(128, 128, 128, 1),
                    errorBorderColor: const Color.fromRGBO(255, 87, 51, 0.7),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(128, 128, 128, 1),
                  ),
                  enableActiveFill: false,
                  errorAnimationController: logic.errorController,
                  controller: logic.pinTextEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) => logic.checkVerifyCode(v),
                  onTap: () {},
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
                GetBuilder<CheckCodeLogic>(builder: (c) {
                  return Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => c.sendVerificationCodeState ==
                                  SendVerificationCodeState.wait
                              ? const Color(0xFFFFFFFF)
                              : PageStyle.mainColor,
                        ),
                        side: MaterialStateProperty.all(BorderSide(
                            width: 1,
                            color: c.sendVerificationCodeState ==
                                    SendVerificationCodeState.wait
                                ? const Color(0xFFF1F1F2)
                                : const Color(0x00000000))),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                        ),
                      ),
                      child: AnimatedContainer(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 200),
                        width: MediaQuery.of(context).size.width * 0.6,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8.w),
                        child: Text(
                          c.sendVerificationCodeState ==
                                  SendVerificationCodeState.wait
                              ? "00:${c.countDown.toString().padLeft(2, '0')}"
                              : StrRes.sendCodeAgain,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: c.sendVerificationCodeState ==
                                    SendVerificationCodeState.wait
                                ? const Color(0xFF6A6A6A)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
