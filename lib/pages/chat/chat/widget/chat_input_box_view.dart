import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chat_voice_record_widget/chat_voice_record_bar.dart';

class ChatInputBoxView extends StatefulWidget {
  const ChatInputBoxView({
    Key? key,
    this.quoteContent,
    required this.textEditingController,
    required this.textFocusNode,
    required this.onToolsBtnTap,
    required this.onSendTap,
    required this.voiceRecordBar,
    required this.onClearQuote,
  }) : super(key: key);
  final String? quoteContent;
  final TextEditingController textEditingController;
  final FocusNode textFocusNode;
  final GestureTapCallback onToolsBtnTap;
  final GestureTapCallback onSendTap;
  final ChatVoiceRecordBar voiceRecordBar;
  final GestureTapCallback onClearQuote;

  @override
  State<ChatInputBoxView> createState() => _ChatInputBoxViewState();
}

class _ChatInputBoxViewState extends State<ChatInputBoxView>
    with SingleTickerProviderStateMixin {
  bool leftKeyboardButton = false;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // controller.forward();
        }
      });

    animation = Tween(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    widget.textEditingController.addListener(() {
      if (widget.textEditingController.text.isEmpty) {
        controller.reverse();
      } else {
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.12),
            offset: const Offset(0, -1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftKeyboardButton ? keyboardLeftBtn() : speakBtn(),
              Flexible(
                child: Stack(
                  children: [
                    Offstage(
                      offstage: leftKeyboardButton,
                      child: Column(
                        children: [
                          buildTextFiled(),
                          if (widget.quoteContent != null &&
                              widget.quoteContent != "")
                            quoteView(),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !leftKeyboardButton,
                      child: widget.voiceRecordBar,
                    ),
                  ],
                ),
              ),
              toolsBtn(),
              Visibility(
                visible: !leftKeyboardButton,
                child: SizedBox(
                  width: 60.0.w * (1.0 - animation.value),
                  child: buildSendButton(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextFiled() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: widget.textEditingController,
        focusNode: widget.textFocusNode,
        autofocus: false,
        minLines: 1,
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          // contentPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 8.h,
          ),
        ),
      ),
    );
  }

  Widget keyboardLeftBtn() {
    return IconButton(
      onPressed: () {
        setState(() {
          leftKeyboardButton = false;
          widget.textFocusNode.requestFocus();
        });
      },
      icon: SvgPicture.asset(ImagesRes.icKeyboard),
    );
  }

  Widget speakBtn() {
    return IconButton(
      onPressed: () {
        setState(() {
          leftKeyboardButton = true;
          widget.textFocusNode.unfocus();
        });
      },
      icon: SvgPicture.asset(ImagesRes.icVoice),
    );
  }

  Widget toolsBtn() {
    return IconButton(
      onPressed: widget.onToolsBtnTap,
      icon: SvgPicture.asset(ImagesRes.icChatTools),
    );
  }

  Widget quoteView() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onClearQuote,
      child: Container(
        margin: EdgeInsets.only(top: 4.h),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.quoteContent!,
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 12.sp,
                ),
              ),
            ),
            SvgPicture.asset(
              ImagesRes.icLogout,
              width: 16.w,
              height: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSendButton() {
    return GestureDetector(
      onTap: widget.onSendTap,
      child: Container(
        height: 33.h,
        width: 60.w,
        // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: PageStyle.chatColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          StrRes.send,
          maxLines: 1,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
