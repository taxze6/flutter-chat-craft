import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/utils/object_util.dart';
import 'package:flutter_chat_craft/widget/cached_image.dart';
import 'package:flutter_chat_craft/widget/click_item.dart';
import 'package:flutter_chat_craft/widget/my_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'profile_logic.dart';

class ProfilePage extends StatelessWidget {
  final logic = Get.find<ProfileLogic>();
  final state = Get.find<ProfileLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(
        title: StrRes.profile,
        backOnTap: Get.back,
      ),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: PageStyle.btnBgColor.withOpacity(0.04),
              offset: Offset(0, -4.w),
              blurRadius: 16.w,
              spreadRadius: 0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.w),
          ),
        ),
        child: Column(
          children: [
            GetBuilder<ProfileLogic>(
                id: 'avatar',
                builder: (_) {
                  return AvatarItem(logic: logic);
                }),
            GetBuilder<ProfileLogic>(
                id: 'motto',
                builder: (_) {
                  return ClickItem(
                    title: StrRes.motto,
                    content: state.userInfo.motto,
                    onTap: logic.modifyMotto,
                  );
                }),
            GetBuilder<ProfileLogic>(
                id: 'nickname',
                builder: (_) {
                  return ClickItem(
                    title: StrRes.nickname,
                    content: state.userInfo.userName,
                    onTap: logic.modifyNickname,
                  );
                }),
            GetBuilder<ProfileLogic>(
                id: 'phone',
                builder: (_) {
                  return ClickItem(
                    title: StrRes.phone,
                    content: ObjectUtil.isNotEmpty(state.userInfo.phone)
                        ? state.userInfo.phone.replaceFirst(RegExp(r'\d{7}'), '****')
                        : state.userInfo.phone,
                    onTap: logic.modifyPhone,
                  );
                }),
            GetBuilder<ProfileLogic>(
                id: 'email',
                builder: (_) {
                  return ClickItem(
                    title: StrRes.email,
                    content: state.userInfo.email,
                    onTap: logic.modifyEmail,
                  );
                }),
            ClickItem(
              title: StrRes.password,
              onTap: logic.modifyPassword,
            ),
            const Spacer(),
            Text(
              'CharCraft v1.0.0',
              style: TextStyle(
                color: PageStyle.tipColor,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 12.w),
            SaveButton(logic: logic),
            SizedBox(height: ScreenUtil().bottomBarHeight + 40.w),
          ],
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.logic,
  });

  final ProfileLogic logic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: ElevatedButton(
        onPressed: logic.save,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50.w)),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.all(PageStyle.btnBgColor),
          alignment: Alignment.center,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
          ),
        ),
        child: Text(
          StrRes.save,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class AvatarItem extends StatelessWidget {
  const AvatarItem({
    super.key,
    required this.logic,
  });

  final ProfileLogic logic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: logic.modifyAvatar,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      StrRes.avatar,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  LoadImage(
                    logic.state.userInfo.avatar,
                    width: 36.w,
                    height: 36.w,
                    radius: 18.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: SvgPicture.asset(
                      ImagesRes.icArrow,
                      width: 6.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFA4A4A4),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xFFEFEFEF),
            ),
          ],
        ),
      ),
    );
  }
}
