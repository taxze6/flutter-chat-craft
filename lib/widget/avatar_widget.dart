import 'package:flutter/material.dart';
import '../res/images.dart';
import 'photo_browser.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
    required this.imageUrl,
    this.imageSize = const Size(64, 64),
    this.onLongPress,
  }) : super(key: key);

  final String imageUrl;
  final Size imageSize;
  final GestureTapCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => clickItemCell(context, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FadeInImage(
          width: imageSize.width,
          height: imageSize.height,
          placeholder: const AssetImage(
            ImagesRes.icBrowser,
          ),
          image: NetworkImage(imageUrl),
          fit: BoxFit.fill,
          fadeInDuration: const Duration(milliseconds: 300), // 渐变显示的时长，可选设置
        ),
      ),
    );
  }

  clickItemCell(context, index) {
    Navigator.of(context).push(FadeRoute(
      page: PhotoBrowser(
        imgDataArr: [imageUrl],
        index: index,
        onLongPress: onLongPress,
      ),
    ));
  }
}
