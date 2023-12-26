import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/images.dart';
import '../../../res/strings.dart';
import 'list_meme_widget.dart';

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

  double listMemeHeight = 52.w;

  //The default state for "meme" is not expanded.
  bool expandMeme = false;

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
                    child: AnimatedContainer(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 6.w,
                          bottom: 24.w,
                          left: 20.w,
                          right: 20.w,
                        ),
                        height: dialogHeight,
                        duration: const Duration(milliseconds: 200),
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
        Text(
          StrRes.meMe,
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(
          height: 6.w,
        ),
        ListMemeWidget(
          imgUrls: [
            "https://img2.baidu.com/it/u=1297740018,2772695612&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1703696400&t=be2473c04aa1bbb4692d1975d1156a6a",
            "https://img1.baidu.com/it/u=2837426444,1036569200&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1703696400&t=2f9ffa9494eff6a665c0bf259dffa374",
            "https://img1.baidu.com/it/u=639770068,2958922633&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1703696400&t=135c1498cdc8be27c7a101fcef1d751f",
            "https://img0.baidu.com/it/u=2675956744,746307251&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1703696400&t=f0be222470ca827b6fcae86e10459c32",
            "https://img2.baidu.com/it/u=444016934,3124738357&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1703696400&t=00ac06ff150b6d17325f1e94b3d730bf",
            "https://img2.baidu.com/it/u=3339674241,1724389523&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1703696400&t=07ce7382a8bbfafa43e248a7411dbda9"
            ],
          addImg: () {},
          onTapRightBtn: () {
            if (expandMeme) {
              dialogHeight -= 400.h;
              listMemeHeight -= 400.h;
              expandMeme = false;
            } else {
              dialogHeight += 400.h;
              listMemeHeight += 400.h;
              expandMeme = true;
            }
            setState(() {});
          },
          listHeight: listMemeHeight,
          expandMeme: expandMeme,
        ),
      ],
    );
  }

  Widget tools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StrRes.function,
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(
          height: 6.w,
        ),
        Container(
          width: 52.w,
          height: 52.w,
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
