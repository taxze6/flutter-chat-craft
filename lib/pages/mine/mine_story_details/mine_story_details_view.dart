import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/mine/mine_story_details/mine_story_details_logic.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MineStoryDetailsPage extends StatefulWidget {
  const MineStoryDetailsPage({Key? key}) : super(key: key);

  @override
  State<MineStoryDetailsPage> createState() => _MineStoryDetailsPageState();
}

class _MineStoryDetailsPageState extends State<MineStoryDetailsPage> {
  final mineStoryDetailsLogic = Get.find<MineStoryDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.w),
          child: Column(
            children: [
              topIndicator(mineStoryDetailsLogic.userStory.media?.length ?? 1),
              avatarAndClose(mineStoryDetailsLogic.userInfo.avatar),
              body(mineStoryDetailsLogic.userStory.media ?? []),
            ],
          ),
        ),
      ),
    );
  }

  Widget topIndicator(int imageLength) {
    double itemWidget = MediaQuery.of(context).size.width - 16.w;
    double padding = (imageLength - 1) * 6.w;
    itemWidget = (itemWidget - padding) / imageLength;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Obx(
        () => Row(
          children: List.generate(
            imageLength,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: itemWidget,
              height: 3.w,
              margin:
                  EdgeInsets.only(right: index != imageLength - 1 ? 6.w : 0.w),
              decoration: BoxDecoration(
                color: mineStoryDetailsLogic.currentImage.value == index
                    ? const Color(0xFF000000)
                    : const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget avatarAndClose(String userAvatar) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarWidget(
            imageUrl: userAvatar,
            imageSize: Size(34.w, 34.w),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget body(List<String> images) {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            SizedBox(
              width: 1.sw,
              height: constraints.maxHeight,
              child: storyImages(images),
            ),
          ],
        );
      }),
    );
  }

  Widget storyImages(List<String> images) {
    return PageView.builder(
      controller: mineStoryDetailsLogic.imagesController,
      itemCount: images.length,
      onPageChanged: (int index) => mineStoryDetailsLogic.changeCurrent(index),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: CachedNetworkImage(
            imageUrl: images[index],
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                color: Colors.grey.shade100,
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                color: Colors.grey.shade100,
              ),
              child: const Center(
                  child: Icon(
                Icons.close,
              )),
            ),
          ),
        );
      },
    );
  }
}
