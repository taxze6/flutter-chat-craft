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
    Container(
      color: Colors.black,
      child: Center(
        child: Text("2"),
      ),
    )
  ];

  List<BottomMenu> bottomMenu = [
    BottomMenu(0, ImagesRes.icHome),
    BottomMenu(1, ImagesRes.icMe),
  ];

  void showHomeDialog(BuildContext context) {
    isShowDialog = true;
    update(["homeDialog"]);
    showDialog(
      context: context,
      barrierColor: const Color(0x573D3D3D),
      builder: (BuildContext context) {
        return HomeDialog(
          toAddFriend: () => toAddFriendPage(),
        );
      },
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
}
