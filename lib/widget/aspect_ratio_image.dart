import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

///渲染之前获取图片的宽高
import 'dart:typed_data';

typedef AsyncImageWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, String url);

typedef AsyncImageFileWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, File file);

typedef AsyncImageMemoryWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, Uint8List bytes);

enum AspectRatioImageType { network, file, asset, memory }

/// 有宽高的Image
class AspectRatioImage extends StatelessWidget {
  String url = "";
  File? imageFile;
  Uint8List? bytes;
  late final ImageProvider provider;
  AspectRatioImageType? type;
  AsyncImageWidgetBuilder<ui.Image>? builder;
  AsyncImageFileWidgetBuilder<ui.Image>? fileBuilder;
  AsyncImageMemoryWidgetBuilder<ui.Image>? bytesBuilder;

  AspectRatioImage.network(
      {super.key, required this.url, required this.builder})
      : provider = NetworkImage(url),
        type = AspectRatioImageType.network;

  AspectRatioImage.file({
    super.key,
    required File this.imageFile,
    required this.fileBuilder,
  })  : provider = FileImage(imageFile),
        type = AspectRatioImageType.file;

  AspectRatioImage.asset(String assetName, {super.key, required this.builder})
      : provider = AssetImage(assetName),
        type = AspectRatioImageType.asset,
        url = assetName;

  AspectRatioImage.memory(Uint8List this.bytes,
      {super.key, required this.bytesBuilder})
      : provider = MemoryImage(bytes),
        type = AspectRatioImageType.memory;

  @override
  Widget build(BuildContext context) {
    final ImageConfiguration config = createLocalImageConfiguration(context);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(config);
    ImageStreamListener? listener;
    listener = ImageStreamListener(
      (ImageInfo image, bool sync) {
        completer.complete(image.image);
        stream.removeListener(listener!);
      },
    );
    stream.addListener(listener);

    return FutureBuilder(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            if (type == AspectRatioImageType.file) {
              return fileBuilder!(context, snapshot, imageFile!);
            } else if (type == AspectRatioImageType.memory) {
              return bytesBuilder!(context, snapshot, bytes!);
            } else {
              return builder!(context, snapshot, url);
            }
          } else {
            return const SizedBox();
          }
        });
  }
}
