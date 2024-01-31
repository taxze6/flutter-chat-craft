import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/utils/object_util.dart';
import 'package:flutter_chat_craft/utils/regex_util.dart';
import 'package:flutter_chat_craft/widget/cached_image.dart';
import 'package:flutter_chat_craft/widget/text_btn.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///设置
class SettingDialog extends StatefulWidget {
  const SettingDialog({
    Key? key,
    required this.title,
    required this.hint,
    this.height,
    this.lineCount,
    this.value,
    this.onConfirm,
    required this.inputDataType,
  }) : super(key: key);

  final String title;
  final String hint;
  final double? height;
  final int? lineCount;
  final String? value;
  final InputDataType inputDataType;
  final Function(String value)? onConfirm;

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  int _currentLength = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.value ?? '';
    _currentLength = widget.value?.length ?? 0;
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
                widget.title,
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
          height: widget.height ?? 60.w,
          width: double.infinity,
          decoration: BoxDecoration(
            color: PageStyle.btnBgColor,
            borderRadius: BorderRadius.circular(12.w),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.topLeft,
          child: TextField(
            key: const Key('name_input'),
            controller: _nameController,
            focusNode: _nameFocusNode,
            autofocus: true,
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
            keyboardType: TextInputType.text,
            maxLines: widget.lineCount ?? 2,
            textAlign: TextAlign.start,
            maxLength: switch (widget.inputDataType) {
              InputDataType.phone => 11,
              InputDataType.email => 30,
              InputDataType.motto => 50,
              InputDataType.nickname => 20,
            },
            onChanged: (value) {
              setState(() {
                _currentLength = value.trim().length;
              });
            },
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: const Color(0xFFCCCCCC),
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w, left: 16.w),
          child: RichText(
            text: TextSpan(
              text: StrRes.maxInput,
              style: TextStyle(
                color: const Color(0xFFCCCCCC),
                fontSize: 12.sp,
              ),
              children: [
                TextSpan(
                  text: (switch (widget.inputDataType) {
                            InputDataType.phone => 11,
                            InputDataType.email => 30,
                            InputDataType.motto => 50,
                            InputDataType.nickname => 20,
                          } -
                          _currentLength)
                      .toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                TextSpan(
                  text: StrRes.word,
                  style: TextStyle(
                    color: const Color(0xFFCCCCCC),
                    fontSize: 12.sp,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );

    final Widget bottomButtonWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
      child: TextBtn(
        text: StrRes.confirm,
        onPressed: () {
          String input = _nameController.text.trim();
          if (widget.inputDataType == InputDataType.phone && !RegexUtil.isMobile(input)) {
            ToastUtils.toastText(widget.hint);
            return;
          }
          if (widget.inputDataType == InputDataType.email && !RegexUtil.isEmail(input)) {
            ToastUtils.toastText(widget.hint);
            return;
          }
          if (widget.inputDataType == InputDataType.motto && ObjectUtil.isEmpty(input)) {
            ToastUtils.toastText(widget.hint);
            return;
          }
          if (widget.inputDataType == InputDataType.nickname && ObjectUtil.isEmpty(input)) {
            ToastUtils.toastText(widget.hint);
            return;
          }
          if (widget.onConfirm != null) {
            widget.onConfirm!(input);
          }
          Get.back();
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

///输入数据源枚举
enum InputDataType {
  /// 手机号
  phone(1),

  /// 邮箱
  email(2),

  /// 座右铭
  motto(3),

  /// 昵称
  nickname(4);

  final int value;

  const InputDataType(this.value);
}
