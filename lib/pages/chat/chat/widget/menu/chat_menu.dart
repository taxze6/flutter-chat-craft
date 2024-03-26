import 'package:flutter/material.dart';
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

class ChatPopupEmoji extends StatelessWidget {
  const ChatPopupEmoji({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flGrinningFace,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flGrinningSquintingFace,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flSmilingFaceWithHearts,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flSmilingFaceWithHearts,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flSmilingFaceWithHalo,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flSmilingFaceWithSunglasses,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flMonkeyFace,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flTigerFace,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flHorseFace,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flPigFace,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flDogFace,
          ),
          FluentUiEmojiIcon(
            w: 30,
            h: 30,
            fl: Fluents.flCatFace,
          ),
        ],
      ),
    );
  }
}
