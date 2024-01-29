import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_craft/utils/image_util.dart';
import 'package:flutter_chat_craft/utils/object_util.dart';
import 'package:flutter_svg/svg.dart';

/// 图片加载
class LoadImage extends StatelessWidget {
  const LoadImage(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.holderImgFit = BoxFit.cover,
    this.format = ImageFormat.png,
    this.color,
    this.radius,
    this.border,
    this.holderImg,
  }) : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BoxFit holderImgFit;
  final ImageFormat format;
  final double? radius;
  final Border? border;
  final String? holderImg;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      color: color,
      cacheManager: CacheManager(
        Config(
          url,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 100,
        ),
      ),
      fadeInDuration: const Duration(milliseconds: 200),
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 0),
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) => ObjectUtil.isNotEmpty(holderImg)
          ? Image.asset(
              ImageUtil.getImgPath(holderImg!, format: format),
              width: width,
              height: height,
              fit: holderImgFit,
            )
          : SizedBox(
              width: width,
              height: height,
            ),
      errorWidget: (context, url, error) => ObjectUtil.isNotEmpty(holderImg)
          ? Image.asset(
              ImageUtil.getImgPath(holderImg!, format: format),
              width: width,
              height: height,
              fit: holderImgFit,
            )
          : SizedBox(
              width: width,
              height: height,
            ),
    );
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.format = ImageFormat.png,
    this.color,
  }) : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageFormat format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (format == ImageFormat.svg) {
      return SvgPicture.asset(
        ImageUtil.getImgPath(image, format: format),
        width: width,
        height: height,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        excludeFromSemantics: true,
      );
    }
    return Image.asset(
      ImageUtil.getImgPath(image, format: format),
      height: height,
      width: width,
      fit: fit,
      color: color,
      excludeFromSemantics: true,
    );
  }
}
