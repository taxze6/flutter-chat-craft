import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../widget/avatar_widget.dart';

final pinColors = [Color(0xFF87C0FF), Color(0xFF0060E7)];
final deleteColors = [Color(0xFFFFC84C), Color(0xFFFFA93C)];
final haveReadColors = [Color(0xFFC9C9C9), Color(0xFF7A7A7A)];

class ConversationItemView extends StatelessWidget {
  const ConversationItemView({
    Key? key,
    required this.userInfo,
    required this.content,
    required this.timeStr,
    this.onTap,
    this.extentRatio = 0.5,
    required this.slideActions,
  }) : super(key: key);

  final UserInfo userInfo;
  final String content;
  final String timeStr;
  final Function()? onTap;
  final double extentRatio;
  final List<SlideItemInfo> slideActions;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: extentRatio,
        children: slideActions.map((e) => _SlideAction(item: e)).toList(),
      ),
      child: GestureDetector(
        onTap: () => onTap?.call(),
        child: Container(
          width: double.infinity,
          height: 62.w,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.w),
          padding: EdgeInsets.symmetric(vertical: 4.w),
          child: Row(
            children: [
              AvatarWidget(
                imageSize: Size(52.w, 52.w),
                radius: 52.w,
                imageUrl: userInfo.avatar,
                onTap: () => onTap?.call(),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo.userName,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF383838),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  Text(""),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideAction extends StatelessWidget {
  final SlideItemInfo item;

  const _SlideAction({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: item.flex,
      child: GestureDetector(
        onTap: () {
          item.onTap?.call();
          Slidable.of(context)?.close();
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: item.boxShadow ??
                [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ],
            gradient: LinearGradient(
              colors: item.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              item.text,
              style: item.textStyle,
            ),
          ),
        ),
      ),
    );
  }

  // Here it is!
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

class SlideItemInfo {
  final String text;
  final TextStyle textStyle;
  final Function()? onTap;
  final List<Color> colors;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final int flex;

  SlideItemInfo({
    required this.text,
    required this.colors,
    this.flex = 1,
    this.onTap,
    this.width,
    this.boxShadow,
    this.textStyle = const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
  });
}
