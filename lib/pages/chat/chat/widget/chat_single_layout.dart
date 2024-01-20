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

  MainAxisAlignment get layoutAlignment =>
      isFromMsg ? MainAxisAlignment.start : MainAxisAlignment.end;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      child: buildContentView(),
    );
  }

  Widget buildContentView() {
    return Row(
      mainAxisAlignment: layoutAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
      ],
    );
  }
}
