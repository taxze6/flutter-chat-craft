import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../res/images.dart';
import 'splash_logic.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final logic = Get.put(SplashLogic());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImagesRes.appIcon,
              width: 82.w,
              height: 82.w,
            ),
            SizedBox(
              height: 26.w,
            ),
            Text(
              StrRes.welcomeUse,
              style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 49.w,
                right: 49.w,
                top: 16.w,
                bottom: 10.w,
              ),
              child: Text(
                StrRes.welcomeUseContent,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF707070),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFFEFEFEF),
                        ),
                      ),
                      child: Text(
                        StrRes.contactMe,
                        style: TextStyle(fontSize: 14.sp, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  ElevatedButton(
                      onPressed: () => logic.enterChatCraft(),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                            (states) => EdgeInsets.symmetric(horizontal: 52.w)),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFFFCC504),
                        ),
                      ),
                      child: Text(
                        StrRes.enterChatCraft,
                        style: TextStyle(fontSize: 14.sp),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
