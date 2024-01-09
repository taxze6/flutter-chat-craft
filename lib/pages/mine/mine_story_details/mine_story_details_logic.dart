import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/models/user_story.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'widget/mine_story_interactive_dialog/mine_story_interactive_dialog.dart';

class MineStoryDetailsLogic extends GetxController {
  late UserInfo userInfo;
  late UserStory userStory;

  bool isShowToolsDialog = false;
  RxInt currentImage = 0.obs;
  PageController imagesController = PageController();
  TextEditingController commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    userInfo = Get.arguments["userInfo"];
    userStory = Get.arguments["userStory"];
  }

  void changeCurrent(int index) {
    currentImage.value = index;
  }

  void showToolsDialog(BuildContext context) {
    isShowToolsDialog = true;
    showDialog(
      context: context,
      barrierColor: const Color(0x573D3D3D),
      builder: (BuildContext context) {
        return MineStoryInteractiveDialog(
          height: 270.w,
          editingController: commentController,
          onSubmitted: storyComment,
        );
      },
    ).then((value) {
      isShowToolsDialog = false;
    });
  }

  void storyComment(String value) {}
}
