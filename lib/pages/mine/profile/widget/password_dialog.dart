import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/apis.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/utils/app_utils.dart';
import 'package:flutter_chat_craft/utils/object_util.dart';
import 'package:flutter_chat_craft/widget/cached_image.dart';
import 'package:flutter_chat_craft/widget/loading_view.dart';
import 'package:flutter_chat_craft/widget/text_btn.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///设置密码
class PasswordDialog extends StatefulWidget {
  const PasswordDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _repeatPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget contentWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15.w),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StrRes.settingPassword,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              InkWell(
                onTap: Get.back,
                child: LoadAssetImage(
                  'replaced/close',
                  width: 20.w,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 40.w,
          width: double.infinity,
          decoration: BoxDecoration(
            color: PageStyle.btnBgColor,
            borderRadius: BorderRadius.circular(12.w),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.topLeft,
          child: TextField(
            key: const Key('current_password_input'),
            controller: _currentPasswordController,
            focusNode: _currentPasswordFocusNode,
            autofocus: true,
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
            keyboardType: TextInputType.text,
            maxLines: 1,
            obscureText: true,
            textAlign: TextAlign.start,
            maxLength: 20,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: StrRes.enterCurrentPassword,
              hintStyle: TextStyle(
                color: const Color(0xFFCCCCCC),
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.w),
        Container(
          height: 40.w,
          width: double.infinity,
          decoration: BoxDecoration(
            color: PageStyle.btnBgColor,
            borderRadius: BorderRadius.circular(12.w),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.topLeft,
          child: TextField(
            key: const Key('new_password_input'),
            controller: _newPasswordController,
            focusNode: _newPasswordFocusNode,
            autofocus: true,
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
            keyboardType: TextInputType.text,
            maxLines: 1,
            obscureText: true,
            textAlign: TextAlign.start,
            maxLength: 20,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: StrRes.enterNewPassword,
              hintStyle: TextStyle(
                color: const Color(0xFFCCCCCC),
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.w),
        Container(
          height: 40.w,
          width: double.infinity,
          decoration: BoxDecoration(
            color: PageStyle.btnBgColor,
            borderRadius: BorderRadius.circular(12.w),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.topLeft,
          child: TextField(
            key: const Key('repeat_password_input'),
            controller: _repeatPasswordController,
            focusNode: _repeatPasswordFocusNode,
            autofocus: true,
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
            keyboardType: TextInputType.text,
            maxLines: 1,
            obscureText: true,
            textAlign: TextAlign.start,
            maxLength: 20,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: StrRes.enterRepeatPassword,
              hintStyle: TextStyle(
                color: const Color(0xFFCCCCCC),
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );

    final Widget bottomButtonWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
      child: TextBtn(
        text: StrRes.confirm,
        onPressed: () async {
          String currentPassword = _currentPasswordController.text.trim();
          String newPassword = _newPasswordController.text.trim();
          String repeatPassword = _repeatPasswordController.text.trim();
          if (ObjectUtil.isEmpty(currentPassword)) {
            ToastUtils.toastText(StrRes.enterCurrentPassword);
            return;
          }
          if (ObjectUtil.isEmpty(newPassword)) {
            ToastUtils.toastText(StrRes.enterNewPassword);
            return;
          }
          if (ObjectUtil.isEmpty(repeatPassword)) {
            ToastUtils.toastText(StrRes.enterRepeatPassword);
            return;
          }
          if (newPassword != repeatPassword) {
            ToastUtils.toastText(StrRes.passwordNotEqual);
            return;
          }
          String encryptedCurrentPassword = await AppUtils.encodeString(currentPassword);
          String encryptedNewPassword = await AppUtils.encodeString(newPassword);
          var data = await LoadingView.singleton
              .wrap(asyncFunction: () => Apis.modifyPassword(password: encryptedCurrentPassword, newPassword: encryptedNewPassword));
          if (data == false) {
            ToastUtils.toastText(StrRes.saveFailed);
          } else {
            ToastUtils.toastText(StrRes.saveSuccess);
            Get.back();
          }
        },
        backgroundColor: PageStyle.mainColor,
        size: Size(double.infinity, 40.w),
        radius: 12.w,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ),
    );

    Widget body = Container(
      width: 270.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          contentWidget,
          bottomButtonWidget,
        ],
      ),
    );

    body = AnimatedContainer(
      alignment: Alignment.center,
      height: 1.sh - MediaQuery.of(context).viewInsets.bottom,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInCubic,
      child: body,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: body,
    );
  }
}
