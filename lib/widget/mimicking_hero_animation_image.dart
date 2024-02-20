import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MimickingHeroAnimationImage extends StatefulWidget {
  const MimickingHeroAnimationImage({
    Key? key,
    required this.imageUrl,
    required this.child,
    required this.oldSize,
  }) : super(key: key);
  final String imageUrl;
  final Widget child;
  final Size oldSize;

  @override
  State<MimickingHeroAnimationImage> createState() =>
      _MimickingHeroAnimationImageState();
}

class _MimickingHeroAnimationImageState
    extends State<MimickingHeroAnimationImage>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<Size> _sizeAnimation;
  bool showBigImage = false;
  bool animationComplete = false;
  late DecorationImage _decorationImage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _decorationImage = _buildDecorationImage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Create a DecorationImage object
  DecorationImage _buildDecorationImage() {
    bool showFileOrNetWorkImg = widget.imageUrl.startsWith('http://') ||
        widget.imageUrl.startsWith('https://');
    return showFileOrNetWorkImg
        ? DecorationImage(
            image: NetworkImage(widget.imageUrl),
            fit: BoxFit.cover,
          )
        : DecorationImage(
            image: FileImage(File(widget.imageUrl)),
            fit: BoxFit.cover,
          );
  }

  void _startAnimation(
      Offset startOffset, Offset endOffset, Size oldImageSize) {
    _offsetAnimation =
        Tween(begin: startOffset, end: endOffset).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _sizeAnimation = Tween(begin: oldImageSize, end: Size(1.sw, 400))
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward().then((value) {
      animationComplete = true;
    });
  }

  void _showMenu(
    BuildContext context,
    TapDownDetails details,
  ) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
        setState(() {
          showBigImage = true;
        });
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        var size = renderBox.size;
        var offset = renderBox.localToGlobal(Offset.zero);
        _startAnimation(
          Offset(offset.dx, offset.dy),
          Offset(
            // (1.sw / 2) - (size.width / 2),
            // (1.sh / 2) - (size.height / 2),
            0,
            (1.sh - 400) / 2,
          ),
          widget.oldSize,
        );
      }
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => _hideMenu(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      color: ColorTween(
                        begin: Colors.transparent,
                        end: Colors.black,
                      ).animate(_animationController).value,
                      child: child,
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      AnimatedBuilder(
                          animation: _offsetAnimation,
                          builder: (c, value) {
                            return AnimatedPositioned(
                              duration: _animationController.duration!,
                              left: _offsetAnimation.value.dx,
                              top: _offsetAnimation.value.dy,
                              child: _buildChildView(
                                  widget.imageUrl, _sizeAnimation.value),
                            );
                          }),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((value) async {
        await Future.delayed(const Duration(milliseconds: 350));
        setState(() {
          showBigImage = false;
        });
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        _showMenu(context, details);
      },
      child: showBigImage
          ? SizedBox(
              width: widget.oldSize.width,
              height: widget.oldSize.height,
            )
          : widget.child,
    );
  }

  Widget _buildChildView(String imgPath, Size imageSize) {
    return GestureDetector(
      onTap: () => _hideMenu(),
      child: AnimatedContainer(
        width: imageSize.width,
        height: imageSize.height,
        duration: _animationController.duration!,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          image: _decorationImage,
        ),
      ),
    );
  }
}
