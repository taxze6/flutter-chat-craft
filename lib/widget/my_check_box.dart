import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyCheckBox extends StatelessWidget {
  const MyCheckBox({
    Key? key,
    required this.isCheck,
    required this.onTap,
  }) : super(key: key);
  final bool isCheck;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color:
                  isCheck ? const Color(0xFFFCC604) : const Color(0xFFA4A4A4)),
          color: isCheck ? const Color(0xFFFCC604) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SvgPicture.asset(ImagesRes.icCheck,
            colorFilter: ColorFilter.mode(
                isCheck ? Colors.black : Colors.transparent, BlendMode.srcIn)),
      ),
    );
  }
}
