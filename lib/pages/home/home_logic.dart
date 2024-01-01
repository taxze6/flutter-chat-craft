import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
import 'package:get/get.dart';
import '../../res/images.dart';
import '../chat/conversation_view.dart';
import 'home_view.dart';
import 'widget/home_dialog.dart';

class HomeLogic extends GetxController {
  PageController pageController = PageController();
  int selectIndex = 0;
  bool isShowDialog = false;
  List<Widget> pages = [
    ConversationPage(),
  ];

  List<BottomMenu> bottomMenu = [
    BottomMenu(0, ImagesRes.icHome),
    BottomMenu(1, ImagesRes.icMe),
  ];

  void showHomeDialog(BuildContext context) {
    isShowDialog = true;
    update(["homeDialog"]);
    Get.dialog(
      barrierColor: const Color(0x573D3D3D),
      HomeDialog(
        toAddFriend: () => toAddFriendPage(),
      ),
    ).then((value) {
      isShowDialog = false;
      update(["homeDialog"]);
    });
  }

  void changeSelectIndex(int value) {
    selectIndex = value.toInt();
    update(["bottomMenu"]);
  }

  void jumpToPage(int index) {
    pageController.jumpToPage(index);
    selectIndex = index;
    update(["bottomMenu"]);
  }

  void toAddFriendPage() {
    AppNavigator.startAddFriend();
  }

  void startMine() {
    AppNavigator.startMine(isMine: true);
  }
}
