import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_popup_menu.dart';

class MenuInfo {
  Widget icon;
  String text;
  TextStyle? textStyle;
  Function()? onTap;
  bool enabled;

  MenuInfo({
    required this.icon,
    required this.text,
    this.textStyle,
    this.onTap,
    this.enabled = true,
  });
}

class ChatMenuStyle {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Color background;
  final double radius;

  ChatMenuStyle({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.background,
    required this.radius,
  });

  const ChatMenuStyle.base()
      : crossAxisCount = 4,
        mainAxisSpacing = 10,
        crossAxisSpacing = 10,
        background = const Color(0xFF666666),
        radius = 4;
}

class ChatLongPressMenu extends StatelessWidget {
  final CustomPopupMenuController controller;
  final List<MenuInfo> menus;
  final ChatMenuStyle menuStyle;

  const ChatLongPressMenu({
    Key? key,
    required this.controller,
    required this.menus,
    this.menuStyle = const ChatMenuStyle.base(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: menuStyle.background,
        borderRadius: BorderRadius.circular(menuStyle.radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children(),
      ),
    );
  }

  List<Widget> _children() {
    var widgets = <Widget>[];
    menus.removeWhere((element) => !element.enabled);
    var rows = menus.length ~/ menuStyle.crossAxisCount;
    if (menus.length % menuStyle.crossAxisCount != 0) {
      rows++;
    }
    for (var i = 0; i < rows; i++) {
      var start = i * menuStyle.crossAxisCount;
      var end = (i + 1) * menuStyle.crossAxisCount;
      if (end > menus.length) {
        end = menus.length;
      }
      var subList = menus.sublist(start, end);
      widgets.add(Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subList
            .map((e) => _menuItem(
                  icon: e.icon,
                  label: e.text,
                  onTap: e.onTap,
                  style: e.textStyle ??
                      TextStyle(
                          fontSize: 10.sp, color: const Color(0xFFFFFFFF)),
                ))
            .toList(),
      ));
    }
    return widgets;
  }

  Widget _menuItem({
    required Widget icon,
    required String label,
    TextStyle? style,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: () {
          controller.hideMenu();
          if (null != onTap) onTap();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: 50.w,
          // constraints: BoxConstraints(maxWidth: 35.w, minWidth: 30.w),
          padding: EdgeInsets.symmetric(
            horizontal: menuStyle.crossAxisSpacing / 2,
            vertical: menuStyle.mainAxisSpacing / 2,
          ),
          child: _ItemView(icon: icon, label: label, style: style),
        ),
      );
}

class _ItemView extends StatelessWidget {
  const _ItemView({
    Key? key,
    required this.icon,
    required this.label,
    this.style,
  }) : super(key: key);
  final Widget icon;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(height: 3.h),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ],
    );
  }
}
