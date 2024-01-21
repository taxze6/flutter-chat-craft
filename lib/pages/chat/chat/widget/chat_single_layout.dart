import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BubbleType {
  send,
  receiver,
}

class ChatSingleLayout extends StatelessWidget {
  const ChatSingleLayout({
    Key? key,
    required this.index,
    required this.child,
    required this.isFromMsg,
    required this.clickSink,
  }) : super(key: key);

  final int index;

  final Widget child;

  final bool isFromMsg;

  final Sink<int> clickSink;

  MainAxisAlignment get layoutAlignment =>
      isFromMsg ? MainAxisAlignment.start : MainAxisAlignment.end;

  Sink<int>? get _onItemClick => clickSink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onItemClick?.add(index),
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
