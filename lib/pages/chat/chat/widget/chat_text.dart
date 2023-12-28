import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatText extends StatelessWidget {
  const ChatText({Key? key, required this.text, required this.isFromMsg}) : super(key: key);
  final String? text;
  final bool isFromMsg;

  Color get bubbleColor =>
      isFromMsg ? const Color(0xFFF7F7F7) : const Color(0xFFFCC504);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 6.w),
        constraints: BoxConstraints(maxWidth: 0.7.sw),
        padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          text ?? "",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
          ),
        ));
  }
}
