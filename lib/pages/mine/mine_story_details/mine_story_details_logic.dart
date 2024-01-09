import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/models/user_story.dart';
import 'package:get/get.dart';

class MineStoryDetailsLogic extends GetxController {
  late UserInfo userInfo;
  late UserStory userStory;

  RxInt currentImage = 0.obs;
  PageController imagesController = PageController();

  @override
  void onInit() {
    super.onInit();
    userInfo = Get.arguments["userInfo"];
    userStory = Get.arguments["userStory"];
  }

  void changeCurrent(int index) {
    currentImage.value = index;
  }
}
