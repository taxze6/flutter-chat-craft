import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastUtils {
  static CancelFunc toastText(String text) {
    return BotToast.showCustomText(
      onlyOne: true,
      toastBuilder: (cancelFunc) {
        return Container(
          // width: 201.w,
          height: 24.w,
          margin: EdgeInsets.symmetric(horizontal: 64.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            color: const Color(0xFF000000),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        );
      },
      wrapAnimation: (controller, cancel, child) => SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(
                CurvedAnimation(parent: controller, curve: Curves.easeOut)),
        child: child,
      ),
      wrapToastAnimation: (controller, cancel, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn)),
        child: child,
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      align: const Alignment(0.1, -0.75),
    );
  }
}
