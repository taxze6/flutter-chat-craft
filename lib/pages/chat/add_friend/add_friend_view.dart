import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/chat/add_friend/add_friend_logic.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/images.dart';
import '../../../utils/touch_close_keyboard.dart';
import '../../../widget/avatar_widget.dart';
import '../../../widget/my_appbar.dart';
import '../../../widget/photo_browser.dart';
import '../../login/widget/login_universal_widget.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final addFriendLogic = Get.find<AddFriendLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: myAppBar(
          title: StrRes.addFriend,
          backOnTap: () => Get.back(),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.w),
            child: Column(
              children: [
                GetBuilder<AddFriendLogic>(
                  id: "searchInput",
                  builder: (logic) => loginInput(
                    controller: addFriendLogic.searchController,
                    focusNode: addFriendLogic.searchFN,
                    hintText: StrRes.searchAddFriendInputHint,
                    textInputAction: TextInputAction.search,
                    centerInput: true,
                    onSubmitted: (v) => addFriendLogic.changeShowBody(v),
                  ),
                ),
                SizedBox(
                  height: 36.w,
                ),
                SlideTransition(
                    position: addFriendLogic.offsetAnimation,
                    child: GetBuilder<AddFriendLogic>(
                      id: "bodyItem",
                      builder: (logic) {
                        return logic.showSearchUserInfo
                            ? logic.searchResultsInfo != null
                                ? Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          AvatarWidget(
                                            imageUrl:
                                                logic.searchResultsInfo!.avatar,
                                            imageSize: Size(64.w, 64.w),
                                          ),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                logic.searchResultsInfo!
                                                    .userName,
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              Text(
                                                logic.searchResultsInfo!.motto,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            StrRes.userNotFound,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  bodyItem(
                                    imagePath: ImagesRes.icShareAdd,
                                    title: StrRes.shareAdd,
                                    onTap: () {},
                                  ),
                                  bodyItem(
                                    imagePath: ImagesRes.icScan,
                                    title: StrRes.scan,
                                    onTap: () {},
                                  ),
                                ],
                              );
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyItem({
    required String imagePath,
    required String title,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(imagePath),
          SizedBox(
            height: 10.w,
          ),
          Text(title),
        ],
      ),
    );
  }
}
