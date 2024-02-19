import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MimickingHeroAnimationImage extends StatefulWidget {
  const MimickingHeroAnimationImage({
    Key? key,
    required this.offset,
    required this.child,
  }) : super(key: key);
  final Offset offset;
  final Widget child;

  @override
  State<MimickingHeroAnimationImage> createState() =>
      _MimickingHeroAnimationImageState();
}

class _MimickingHeroAnimationImageState
    extends State<MimickingHeroAnimationImage> {
  OverlayEntry? _overlayEntry;

  void _showMenu(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => _hideMenu(),
              behavior: HitTestBehavior.translucent,
              // onPanDown: (details) => _hideMenu(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 1.sw,
                height: 1.sh,
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: const Duration(seconds: 1),
                      left: offset.dx + 200,
                      top: offset.dy + 200,
                      width: size.width,
                      height: size.height,
                      child: GestureDetector(
                        onTap: () {
                          _hideMenu();
                        },
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("aa");
        _showMenu(context);
      },
      child: widget.child,
    );
  }
}
