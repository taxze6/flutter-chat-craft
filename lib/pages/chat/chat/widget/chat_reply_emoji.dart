import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/fluent_emoji_icon_data.dart';

class ChatReplyEmoji extends StatelessWidget {
  const ChatReplyEmoji({
    Key? key,
    this.replyEmoji,
    required this.isFromMsg,
  }) : super(key: key);
  final List<String>? replyEmoji;
  final bool isFromMsg;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 6.w),
      width: double.infinity,
      constraints: BoxConstraints(
          maxWidth: (replyEmoji!.length * 20.w + 24.w) > 0.7.sw
              ? 0.7.sw
              : (replyEmoji!.length * 20.w + 24.w).toDouble(),
          maxHeight: 32.w),
      padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isFromMsg ? 0 : 12),
          topRight: Radius.circular(isFromMsg ? 12 : 0),
          bottomRight: const Radius.circular(12),
          bottomLeft: const Radius.circular(12),
        ),
      ),
      child: ListView.builder(
        itemCount: replyEmoji?.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: FluentUiEmojiIcon(
              w: 16.w,
              h: 16.w,
              fl: FluentEmojiIconData.stringGetFluentsData(
                replyEmoji![index],
              ),
            ),
          );
        },
      ),
    );
  }
}
