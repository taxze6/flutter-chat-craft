import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatVoiceRecordBar extends StatefulWidget {
  const ChatVoiceRecordBar({
    Key? key,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onLongPressMoveUpdate,
  }) : super(key: key);

  final Function(LongPressStartDetails details) onLongPressStart;
  final Function(LongPressEndDetails details) onLongPressEnd;
  final Function(LongPressMoveUpdateDetails details) onLongPressMoveUpdate;

  @override
  State<ChatVoiceRecordBar> createState() => _ChatVoiceRecordBarState();
}

class _ChatVoiceRecordBarState extends State<ChatVoiceRecordBar> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (details) {
        widget.onLongPressStart(details);
        setState(() {
          _pressing = true;
        });
      },
      onLongPressEnd: (details) {
        widget.onLongPressEnd(details);
        setState(() {
          _pressing = false;
        });
      },
      onLongPressMoveUpdate: (details) {
        widget.onLongPressMoveUpdate(details);
        // Offset global = details.globalPosition;
        // Offset local = details.localPosition;
        // print('global:$global');
        // print('local:$local');
      },
      child: Container(
        height: 42.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF).withOpacity(_pressing ? 0.3 : 1),
          borderRadius: BorderRadius.circular(4),
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color(0xFF000000).withOpacity(0.12),
          //     offset: const Offset(0, -1),
          //     blurRadius: 4,
          //     spreadRadius: 0,
          //   ),
          // ],
        ),
        child: Text(
          _pressing ? StrRes.releaseSend : StrRes.pressSpeak,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
