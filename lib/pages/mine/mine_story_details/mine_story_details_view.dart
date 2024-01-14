import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/mine/mine_story_details/mine_story_details_logic.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../widget/barrage/barrage_controller.dart';
import '../../../widget/barrage/barrage_view.dart';

class MineStoryDetailsPage extends StatefulWidget {
  const MineStoryDetailsPage({Key? key}) : super(key: key);

  @override
  State<MineStoryDetailsPage> createState() => _MineStoryDetailsPageState();
}

class _MineStoryDetailsPageState extends State<MineStoryDetailsPage> {
  final mineStoryDetailsLogic = Get.find<MineStoryDetailsLogic>();
  BarrageController controller = BarrageController();

  addDanmaku() {
    int random = Random().nextInt(20);
    controller.addDanmaku('s' + 's' * random,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    int random1 = Random().nextInt(20);
    controller.addDanmaku('s' + 's' * random1,
        barrageType: BarrageType.fixed,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);
  }

  Size get areaSize => MediaQuery.of(context).size;

  void _incrementCounter() {
    addDanmaku();
    int random = Random().nextInt(20);
    controller.addDanmaku('s' + 's' * random,
        barrageType: BarrageType.fixed,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      controller.init(areaSize);
      controller.setBulletTapCallBack(setBulletTapCallBack);
      addDanmaku();
      addDanmaku();
    });
  }

  setBulletTapCallBack(BarrageModel bulletModel) {
    print(bulletModel.text);
  }

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
            Positioned(
              bottom: 20.w,
              left: 0,
              right: 0,
              child: storyTools(),
            ),
            Positioned(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: BarrageView(
                  controller: controller,
                  bulletTapCallBack: (BarrageModel) {},
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget storyImages(List<String> images) {
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
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

  Widget storyTools() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => itemTool(
            () => mineStoryDetailsLogic.addLikeOrRemoveLike(),
            ImagesRes.icStoryLike,
            mineStoryDetailsLogic.isLike.value
                ? PageStyle.chatColor
                : const Color(0xFF383838))),
        itemTool(() => mineStoryDetailsLogic.showToolsDialog(context),
            ImagesRes.icStoryComment, const Color(0xFF383838)),
        itemTool(() {}, ImagesRes.icStoryCollect, const Color(0xFF383838)),
        itemTool(() {}, ImagesRes.icStoryShare, const Color(0xFF383838)),
      ],
    );
  }

  Widget itemTool(GestureTapCallback onTap, String iconPath, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        padding: EdgeInsets.all(10.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
