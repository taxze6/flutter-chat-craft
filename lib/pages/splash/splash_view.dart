import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return contactMe();
                            });
                      },
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
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contactMe() {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AvatarWidget(
                imageSize: Size(68.w, 68.w),
                radius: 68.w,
                imageUrl:
                    "https://p9-passport.byteacctimg.com/img/user-avatar/af5f7ee5f0c449f25fc0b32c050bf100~90x90.awebp",
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Taxze",
                    style: TextStyle(
                      fontSize: 22.sp,
                    ),
                  ),
                  Text(
                    "Hi, I’m taxze.",
                    style: TextStyle(
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "I'm looking for a Flutter software engineer position in Hangzhou or remotely. Please feel free to contact me.",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Contact information",
              style: TextStyle(
                fontSize: 18.sp,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/share/wechat.png",
                width: 48.w,
                height: 48.w,
                fit: BoxFit.cover,
              ),
              GestureDetector(
                onTap: () {
                  _launchUrl(
                      Uri.parse("https://juejin.cn/user/598591926699358"));
                },
                child: Image.asset(
                  "assets/images/share/juejin.png",
                  width: 48.w,
                  height: 48.w,
                  fit: BoxFit.cover,
                ),
              ),
              Image.asset(
                "assets/images/share/github.png",
                width: 48.w,
                height: 48.w,
                fit: BoxFit.cover,
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
