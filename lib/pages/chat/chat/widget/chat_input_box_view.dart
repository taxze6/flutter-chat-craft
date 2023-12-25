import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatInputBoxView extends StatefulWidget {
  const ChatInputBoxView({
    Key? key,
    this.quoteContent,
    required this.textEditingController,
    required this.textFocusNode,
    required this.onSendTap,
  }) : super(key: key);
  final String? quoteContent;
  final TextEditingController textEditingController;
  final FocusNode textFocusNode;
  final GestureTapCallback onSendTap;

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
                              "" != widget.quoteContent)
                            quoteView(),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !leftKeyboardButton,
                      child: voiceRecordBar(),
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
      onPressed: () {},
      icon: SvgPicture.asset(ImagesRes.icKeyboard),
    );
  }

  Widget speakBtn() {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(ImagesRes.icVoice),
    );
  }

  Widget toolsBtn() {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(ImagesRes.icChatTools),
    );
  }

  Widget voiceRecordBar() {
    return Container();
  }

  Widget quoteView() {
    return Container();
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
