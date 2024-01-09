import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListReplyInputWidget extends StatelessWidget {
  const ListReplyInputWidget(
      {Key? key, required this.controller, required this.onSubmitted})
      : super(key: key);

  final TextEditingController controller;
  final Function(String value) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFF7F7F7),
      ),
      child: TextField(
        controller: controller,
        maxLength: 120,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintText: StrRes.storyCommentHintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        style: TextStyle(
          fontSize: 14.sp,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
