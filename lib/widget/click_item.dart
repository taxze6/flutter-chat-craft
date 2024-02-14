import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/utils/object_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ClickItem extends StatelessWidget {
  const ClickItem({
    Key? key,
    this.onTap,
    required this.title,
    this.icon,
    this.content,
    this.verticalPadding,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String title;
  final String? icon;
  final String? content;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 15.w),
              child: Row(
                children: [
                  if (icon != null)
                    Padding(
                      padding: EdgeInsets.only(right: 18.w),
                      child: SvgPicture.asset(
                        icon!,
                        width: 18.w,
                        height: 18.w,
                      ),
                    ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: ObjectUtil.isNotEmpty(content)
                        ? Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                content!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: PageStyle.contentColor,
                                ),
                              ),
                            ),
                        )
                        : const SizedBox(),
                  ),
                  if (onTap != null)
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
