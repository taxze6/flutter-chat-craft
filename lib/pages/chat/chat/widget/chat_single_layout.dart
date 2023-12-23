import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BubbleType {
  send,
  receiver,
}

class ChatSingleLayout extends StatelessWidget {
  const ChatSingleLayout(
      {Key? key, required this.child, required this.isFromMsg})
      : super(key: key);

  final Widget child;

  final bool isFromMsg;

  Color get bubbleColor =>
      isFromMsg ? const Color(0xFFF7F7F7) : const Color(0xFFFCC504);

  MainAxisAlignment get layoutAlignment =>
      isFromMsg ? MainAxisAlignment.start : MainAxisAlignment.end;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        child: buildContentView(),
      ),
    );
  }

  Widget buildContentView() {
    return Row(
      mainAxisAlignment: layoutAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 6.w),
          constraints: BoxConstraints(maxWidth: 0.6.sw),
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: child,
        ),
      ],
    );
  }
}
