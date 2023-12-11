import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';
import '../../../common/global_data.dart';
import '../../../res/strings.dart';
import '../../../utils/app_utils.dart';
import '../../../widget/loading_view.dart';
import '../../../widget/toast_utils.dart';

class AddFriendLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFN = FocusNode();
  late AnimationController controller;
  late Animation<Offset> offsetAnimation;
  bool showSearchUserInfo = false;
  UserInfo? searchResultsInfo;

  @override
  void onInit() {
    super.onInit();
    listenFocus();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.forward();
    });
  }

  @override
  void onClose() {
    super.onClose();
    searchFN.dispose();
    searchController.dispose();
  }

  void listenFocus() {
    searchFN.addListener(() {
      if (searchFN.hasFocus) {}
      update(["searchInput"]);
    });
  }

  void changeShowBody(String value) {
    if (value.isNotEmpty) {
      if (value != GlobalData.userInfo.userName) {
        controller.reverse().then((v) {
          showSearchUserInfo = !showSearchUserInfo;
          searchUser(value);
          update(["bodyItem"]);
          controller.forward();
        });
      } else {
        ToastUtils.toastText(StrRes.canNotAddSelf);
      }
    } else {
      ToastUtils.toastText(StrRes.inputEmptyReminder);
    }
  }

  Future<bool> searchUser(String name) async {
    var data = await LoadingView.singleton
        .wrap(asyncFunction: () => Apis.findWithUserName(name: name));
    if (data == false) {
      ToastUtils.toastText(StrRes.userNotFound);
    } else {
      UserInfo info = UserInfo.fromJson(data);
      searchResultsInfo = info;
      update(["bodyItem"]);
    }
    return false;
  }
}
