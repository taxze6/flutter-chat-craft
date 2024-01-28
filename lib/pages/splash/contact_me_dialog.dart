import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../res/images.dart';

class ContactMeDialog extends StatefulWidget {
  const ContactMeDialog({
    super.key,
  });

  @override
  State<ContactMeDialog> createState() => _ContactMeDialogState();
}

class _ContactMeDialogState extends State<ContactMeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    _controller.forward();
  }

  void _closeDialogWithAnimation() {
    setState(() {
      _offsetAnimation = Tween<Offset>(
        begin: const Offset(-2, 0),
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
    return GestureDetector(
      onTap: () {
        _closeDialogWithAnimation();
      },
      child: Material(
        color: const Color(0x00000000),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SlideTransition(
                  position: _offsetAnimation,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 24.w,
                        horizontal: 14.w,
                      ),
                      height: 0.9.sh,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(38))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              ImagesRes.icBackLeft,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed: _closeDialogWithAnimation,
                          ),
                          Text(
                            "Take a screenshot to save the QR code and add me on WeChat. This project has a related discussion group, by the way.",
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Image.asset(
                              "assets/images/share/wechat_taxze.jpg",
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
