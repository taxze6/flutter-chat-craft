import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'message_custom_popup.dart';

class MenuInfo {
  Widget icon;
  String text;
  Function()? onTap;

  MenuInfo({
    required this.icon,
    required this.text,
    this.onTap,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: _children(),
    );
  }

  Widget _children() {
    return Container(
      width: 100.w,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            menus.length,
            (index) => _menuItem(
                  icon: menus[index].icon,
                  label: menus[index].text,
                  onTap: menus[index].onTap,
                )),
      ),
    );
  }

  Widget _menuItem({
    required Widget icon,
    required String label,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: () {
          controller.hideMenu();
          if (null != onTap) onTap();
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
        mainAxisSize: MainAxisSize.max,
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
      width: 100.w,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
      height: 28.w,
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
    );
  }
}
