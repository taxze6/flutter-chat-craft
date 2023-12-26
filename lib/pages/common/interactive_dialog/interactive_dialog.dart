import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/images.dart';
import '../../../res/strings.dart';

class InteractiveDialog extends StatefulWidget {
  const InteractiveDialog({Key? key, this.height}) : super(key: key);

  final double? height;

  @override
  State<InteractiveDialog> createState() => _InteractiveDialogState();
}

class _InteractiveDialogState extends State<InteractiveDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late double dialogHeight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    _controller.forward();
    if (widget.height != null) {
      dialogHeight = widget.height!;
    } else {
      dialogHeight = 233.h;
    }
  }

  void _closeDialogWithAnimation() {
    setState(() {
      _offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ));
    });
    _controller.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    return GestureDetector(
      onTap: () {
        _closeDialogWithAnimation();
      },
      child: Material(
        color: const Color(0x00000000),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SlideTransition(
                  position: _offsetAnimation,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 6.w,
                          bottom: 24.w,
                          left: 20.w,
                          right: 20.w,
                        ),
                        height: dialogHeight,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(38))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: grayDivider()),
                            Padding(
                              padding: EdgeInsets.only(top: 16.w, bottom: 10.w),
                              child: promotionalCard(),
                            ),
                            meMe(),
                            SizedBox(
                              height: 10.w,
                            ),
                            tools(),
                          ],
                        )),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget grayDivider() {
    return Container(
      width: 38.w,
      height: 4.w,
      decoration: BoxDecoration(
        color: const Color(0xFFDEDEDE),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget promotionalCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        StrRes.promotionalCardText,
        style: TextStyle(
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget meMe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StrRes.meMe,style: TextStyle(
            fontSize: 14.sp
        ),),
        SizedBox(
          height: 6.w,
        ),
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget tools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StrRes.function,style: TextStyle(
          fontSize: 14.sp
        ),),
        SizedBox(
          height: 6.w,
        ),
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
