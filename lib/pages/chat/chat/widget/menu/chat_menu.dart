import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/fluent_emoji_icon_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'message_custom_popup.dart';

class MenuInfo {
  Widget icon;
  String text;
  Function() onTap;

  MenuInfo({
    required this.icon,
    required this.text,
    required this.onTap,
  });
}

class ChatLongPressMenu extends StatelessWidget {
  final MessageCustomPopupMenuController controller;
  final List<MenuInfo> menus;

  const ChatLongPressMenu({
    Key? key,
    required this.controller,
    required this.menus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: _children(),
    );
  }

  Widget _children() {
    return Container(
      width: 120.w,
      padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 3),
              blurRadius: 8,
            )
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          menus.length,
          (index) => _menuItem(
            icon: menus[index].icon,
            label: menus[index].text,
            onMenuItemTap: menus[index].onTap,
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required Widget icon,
    required String label,
    required Function() onMenuItemTap,
  }) =>
      GestureDetector(
        onTap: () {
          controller.hideMenu();
          onMenuItemTap();
        },
        behavior: HitTestBehavior.translucent,
        child: _ItemView(icon: icon, label: label),
      );
}

class _ItemView extends StatelessWidget {
  const _ItemView({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.w),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 4.w),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class ChatPopupPartEmoji extends StatelessWidget {
  const ChatPopupPartEmoji(
      {super.key, required this.controller, required this.replyEmoji});

  final MessageCustomPopupMenuController controller;
  final Function(String value) replyEmoji;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            controller.showMoreEmoji();
          },
          child: Container(
            width: 32.w,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 32.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 3),
                    blurRadius: 8.0,
                  )
                ]),
            child: const Icon(Icons.data_usage),
          ),
        ),
        Container(
          width: 140.w,
          padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
          height: 32.w,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, 3),
                  blurRadius: 8.0,
                )
              ]),
          child: ListView.builder(
            itemCount: 6,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  replyEmoji(FluentEmojiIconData.emojiNames[index]);
                  controller.hideMenu();
                },
                child: FluentUiEmojiIcon(
                  w: 28.w,
                  h: 28.w,
                  fl: FluentEmojiIconData.stringGetFluentsData(
                    FluentEmojiIconData.emojiNames[index],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChatPopupAllEmoji extends StatelessWidget {
  const ChatPopupAllEmoji(
      {super.key, required this.controller, required this.replyEmoji});

  final MessageCustomPopupMenuController controller;

  final Function(String value) replyEmoji;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 1.sw * 0.64,
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 10.w),
          // height: 32.w,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, 3),
                  blurRadius: 8.0,
                )
              ]),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: FluentEmojiIconData.emojiNames.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  replyEmoji(FluentEmojiIconData.emojiNames[index]);
                  controller.hideMenu();
                },
                child: FluentUiEmojiIcon(
                  w: 28.w,
                  h: 28.w,
                  fl: FluentEmojiIconData.stringGetFluentsData(
                    FluentEmojiIconData.emojiNames[index],
                  ),
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.closeMoreEmoji();
          },
          child: Container(
            width: 42.w,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 42.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 3),
                    blurRadius: 8.0,
                  )
                ]),
            child: const Icon(Icons.arrow_circle_up_sharp),
          ),
        ),
      ],
    );
  }
}
