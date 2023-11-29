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

titleText({required String title, String? content}) {
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
            Text(
              content,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF707070)),
            )
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
  bool obscureText = false,
}) {
  return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: focusNode.hasFocus
                  ? inputSelectedColor
                  : inputUnSelectedColor),
          borderRadius: BorderRadius.circular(20.w)),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.w),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        cursorColor: inputSelectedColor,
        textAlign: TextAlign.start,
        obscureText: obscureText,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          // contentPadding: const EdgeInsets.all(0.0),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF5F5F5F),
          ),
          isDense: true,
        ),
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
