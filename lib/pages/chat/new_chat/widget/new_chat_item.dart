import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/user_info.dart';

class NewChatItem extends StatelessWidget {
  const NewChatItem({
    Key? key,
    required this.user,
    this.isShowSeparator = true,
    required this.onTap,
  }) : super(key: key);

  final UserInfo user;

  final bool isShowSeparator;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20.0.w),
          child: Column(
            children: [
              Row(
                children: [
                  AvatarWidget(
                    imageUrl: user.avatar,
                    radius: 16.w,
                    imageSize: Size(48.w, 48.w),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        user.motto,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 50.w, right: 24.w),
                height: 1,
                color: Colors.grey.shade100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
