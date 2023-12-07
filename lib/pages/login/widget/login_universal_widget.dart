import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../res/images.dart';

const Color inputSelectedColor = Color(0xFFFCC604);
const Color inputUnSelectedColor = Color(0xFFDFDFDF);
const Color unClickBtnTextColor = Color(0xFF6A6A6A);
const Color clickBtnTextColor = Color(0xFF000000);

loginAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: EdgeInsets.only(left: 18.w),
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 11.w),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color(0xFFF5F5F6)),
        child: SvgPicture.asset(
          ImagesRes.back,
          width: 12.w,
          height: 12.w,
        ),
      ),
    ),
    leadingWidth: 52.w,
  );
}

titleText({required String title, String? content, String? contentImportant}) {
  return content != null
      ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6.w,
            ),
            contentImportant == null
                ? Text(
                    content,
                    style: TextStyle(
                        fontSize: 14.sp, color: const Color(0xFF707070)),
                  )
                : RichText(
                    text: TextSpan(children: [
                    TextSpan(
                      text: content,
                      style: TextStyle(
                          fontSize: 14.sp, color: const Color(0xFF707070)),
                    ),
                    TextSpan(
                      text: contentImportant,
                      style: TextStyle(
                          fontSize: 14.sp, color: const Color(0xFF383838)),
                    )
                  ]))
          ],
        )
      : Text(
          title,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        );
}

loginInput({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hintText,
  TextInputAction textInputAction = TextInputAction.none,
  bool centerInput = false,
  bool obscureText = false,
  ValueChanged<String>? onSubmitted,
}) {
  return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: focusNode.hasFocus
                  ? inputSelectedColor
                  : inputUnSelectedColor),
          borderRadius: BorderRadius.circular(30.w)),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      child: TextField(
        textInputAction: textInputAction,
        focusNode: focusNode,
        controller: controller,
        cursorColor: inputSelectedColor,
        textAlign: centerInput ? TextAlign.center : TextAlign.start,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          isCollapsed: true,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF5F5F5F),
          ),
          isDense: false,
        ),
        onSubmitted: onSubmitted,
      ));
}

loginButton({
  required String text,
  required Function() onTap,
  required bool isClick,
}) {
  return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => isClick ? inputSelectedColor : inputUnSelectedColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.w),
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: isClick ? clickBtnTextColor : unClickBtnTextColor,
          ),
        ),
      ));
}
