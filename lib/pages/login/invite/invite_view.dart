import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/utils/object_util.dart';
import 'package:flutter_chat_craft/widget/cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'invite_logic.dart';

class InvitePage extends StatelessWidget {
  final logic = Get.find<InviteLogic>();
  final state = Get.find<InviteLogic>().state;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Material(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<InviteLogic>(
                          id: 'avatar',
                          builder: (_) {
                            return InkWell(
                              onTap: logic.setAvatar,
                              child: ObjectUtil.isNotEmpty(state.avatar)
                                  ? LoadImage(
                                      state.avatar!,
                                      width: 97.w,
                                      height: 97.w,
                                      fit: BoxFit.cover,
                                      radius: 24.w,
                                    )
                                  : SizedBox(
                                      width: 97.w,
                                      height: 97.w,
                                      child: DottedBorder(
                                        color: const Color(0xFFFCC604),
                                        strokeWidth: 4.w,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(24.w),
                                        dashPattern: [10.w, 2.w],
                                        child: Center(
                                          child: Container(
                                            width: 36.w,
                                            height: 36.w,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEFEFEF),
                                              borderRadius: BorderRadius.circular(10.w),
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 24.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            );
                          }),
                      InkWell(
                        onTap: logic.toNext,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F6),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          width: 35.w,
                          height: 35.w,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 16.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    state.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.w),
                  RichText(
                    text: TextSpan(
                      text: StrRes.inviteStartPart,
                      style: TextStyle(
                        color: const Color(0xFFACACAC),
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                          text: state.email,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                        ),
                        TextSpan(
                          text: StrRes.inviteEndPart,
                          style: TextStyle(
                            color: const Color(0xFFACACAC),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    StrRes.motto,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 15.w),
                  GetBuilder<InviteLogic>(
                      id: 'motto',
                      builder: (_) {
                        return InkWell(
                          onTap: logic.setMotto,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                            decoration: BoxDecoration(
                              color: ObjectUtil.isNotEmpty(state.motto) ? PageStyle.mainColor : PageStyle.btnBgColor,
                              borderRadius: BorderRadius.circular(16.w),
                            ),
                            child: Text(
                              ObjectUtil.isNotEmpty(state.motto) ? state.motto! : StrRes.whatsYourMotto,
                              style: TextStyle(
                                color: ObjectUtil.isNotEmpty(state.motto) ? Colors.black : PageStyle.contentColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 15.w),
                  Text(
                    StrRes.phone,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 15.w),
                  GetBuilder<InviteLogic>(
                      id: 'phone',
                      builder: (_) {
                        return InkWell(
                          onTap: logic.setPhone,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                            decoration: BoxDecoration(
                              color: ObjectUtil.isNotEmpty(state.phone) ? PageStyle.mainColor : PageStyle.btnBgColor,
                              borderRadius: BorderRadius.circular(16.w),
                            ),
                            child: Text(
                              ObjectUtil.isNotEmpty(state.phone) ? state.phone! : StrRes.whatsYourPhone,
                              style: TextStyle(
                                color: ObjectUtil.isNotEmpty(state.phone) ? Colors.black : PageStyle.contentColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
