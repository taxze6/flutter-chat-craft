import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/mine/mine_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key, required this.controller}) : super(key: key);
  final MineLogic controller;

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  late var mineLogic;

  @override
  void initState() {
    super.initState();
    mineLogic = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        color: const Color(0x00000000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 1.sw,
              height: 0.9.sh,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(42.w),
                  topRight: Radius.circular(42.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
