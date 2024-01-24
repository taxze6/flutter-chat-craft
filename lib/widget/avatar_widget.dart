import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import '../res/images.dart';
import '../res/strings.dart';
import 'photo_browser.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
    required this.imageUrl,
    this.imageSize = const Size(64, 64),
    this.radius = 8,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  final String imageUrl;
  final Size imageSize;
  final double radius;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => clickItemCell(context, 0),
      // child: ClipRRect(
      //   borderRadius: BorderRadius.circular(radius),
      //   child: FadeInImage(
      //     width: imageSize.width,
      //     height: imageSize.height,
      //     placeholder: const AssetImage(
      //       ImagesRes.icBrowser,
      //     ),
      //     image: NetworkImage(imageUrl),
      //     fit: BoxFit.fill,
      //     fadeInDuration: const Duration(milliseconds: 300),
      //   ),
      // ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: imageSize.width,
        height: imageSize.height,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            color: Colors.grey.shade100,
          ),
          child: Center(
              child: SizedBox(
                  width: imageSize.width / 3,
                  height: imageSize.width / 3,
                  child: const CircularProgressIndicator())),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            color: Colors.grey.shade100,
          ),
          child: const Center(
              child: Icon(
            Icons.eco_rounded,
          )),
        ),
      ),
    );
  }

  clickItemCell(context, index) {
    if (imageUrl.isNotEmpty) {
      Navigator.of(context).push(FadeRoute(
        page: PhotoBrowser(
          imgDataArr: [imageUrl],
          index: index,
          onLongPress: onLongPress,
        ),
      ));
    } else {
      ToastUtils.toastText(StrRes.notImageData);
    }
  }
}
