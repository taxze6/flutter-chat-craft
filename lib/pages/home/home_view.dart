import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/home/home_logic.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../res/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final homeLogic = Get.find<HomeLogic>();
  bool hidden = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      hidden = state != AppLifecycleState.resumed;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if (hidden) {
      return Material(
        child: Center(
          child: SvgPicture.asset(
            ImagesRes.appIcon,
            width: 82.w,
            height: 82.w,
          ),
        ),
      );
    } else {
      return Scaffold(
        body: PageView.builder(
          itemCount: homeLogic.pages.length,
          controller: homeLogic.pageController,
          onPageChanged: (value) => homeLogic.changeSelectIndex(value),
          itemBuilder: (itemBuilder, index) {
            return homeLogic.pages[index];
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => homeLogic.jumpToPage(0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: GetBuilder<HomeLogic>(
                        id: "bottomMenu",
                        builder: (c) {
                          return SvgPicture.asset(
                            c.bottomMenu[0].imagePath,
                            colorFilter: ColorFilter.mode(
                              c.selectIndex == 0
                                  ? PageStyle.mainColor
                                  : Colors.black,
                              BlendMode.srcIn,
                            ),
                          );
                        }),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => homeLogic.showHomeDialog(context),
                child: GetBuilder<HomeLogic>(
                    id: "homeDialog",
                    builder: (c) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: c.isShowDialog
                              ? Colors.transparent
                              : Colors.black,
                          borderRadius: BorderRadius.circular(15.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StrRes.newChat,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Expanded(
                child: GestureDetector(
                  // onTap: () => homeLogic.jumpToPage(1),
                  onTap: homeLogic.startMine,
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: GetBuilder<HomeLogic>(
                        id: "bottomMenu",
                        builder: (c) {
                          return SvgPicture.asset(
                            c.bottomMenu[1].imagePath,
                            colorFilter: ColorFilter.mode(
                              c.selectIndex == 1
                                  ? PageStyle.mainColor
                                  : Colors.black,
                              BlendMode.srcIn,
                            ),
                          );
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}

class BottomMenu {
  final int id;
  final String imagePath;

  BottomMenu(this.id, this.imagePath);
}
