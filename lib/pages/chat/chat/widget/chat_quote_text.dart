import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/im/im_utils.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatQuoteText extends StatefulWidget {
  final Message? message;
  final bool isFromMsg;

  const ChatQuoteText({Key? key, this.message, required this.isFromMsg})
      : super(key: key);

  @override
  _ChatQuoteTextState createState() => _ChatQuoteTextState();
}

class _ChatQuoteTextState extends State<ChatQuoteText> {
  final GlobalKey _columnKey = GlobalKey();
  double _columnHeight = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _updateColumnHeight();
    });
    super.initState();
  }

  void _updateColumnHeight() {
    final RenderBox renderBox =
        _columnKey.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      _columnHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.w),
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
      decoration: BoxDecoration(
        color: widget.isFromMsg
            ? const Color(0xFFF7F7F7)
            : const Color(0xFFFCC504),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1.2.w,
                height: _columnHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Column(
                  key: _columnKey,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message?.quoteMessage?.messageSenderName ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      IMUtils.messageTypeToString(
                        messageType: widget.message!.quoteMessage!.contentType!,
                        content: widget.message?.quoteMessage?.content ?? "",
                      ),
                      style: TextStyle(
                        color: const Color(0xFF4A4A4A),
                        fontSize: 10.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          SelectableText(
            widget.message?.content ?? "",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
