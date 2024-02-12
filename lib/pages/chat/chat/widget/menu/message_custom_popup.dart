import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_menu.dart';

class MessageCustomPopupMenuController extends ChangeNotifier {
  bool menuIsShowing = false;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}

class MessageCustomPopupMenu extends StatefulWidget {
  const MessageCustomPopupMenu({
    Key? key,
    required this.child,
    this.controller,
    required this.menuWidgets,
  }) : super(key: key);

  final Widget child;
  final MessageCustomPopupMenuController? controller;
  final List<MenuInfo> menuWidgets;

  @override
  State<MessageCustomPopupMenu> createState() => _MessageCustomPopupMenuState();
}

class _MessageCustomPopupMenuState extends State<MessageCustomPopupMenu> {
  MessageCustomPopupMenuController? _controller;
  OverlayEntry? _overlayEntry;
  RenderBox? _parentBox;
  LongPressStartDetails? _longPressStartDetails;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller ??= MessageCustomPopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      _parentBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    super.dispose();
  }

  _updateView() {
    if (_controller?.menuIsShowing ?? false) {
      _showMenu(context, _longPressStartDetails!);
    } else {
      _hideMenu();
    }
  }

  /// 显示浮层
  void _showMenu(BuildContext context, LongPressStartDetails details) {
    /// 防止重复创建，不然失去句柄的OverlayEntry将无法消除
    if (_overlayEntry == null) {
      Alignment targetAlignment = Alignment.bottomRight;
      Alignment followerAlignment = Alignment.topLeft;
      Offset offset = const Offset(-20, -20);
      bool isReceived = false;
      if ((details.globalPosition.dx + 100.w) > 1.sw) {
        targetAlignment = Alignment.bottomLeft;
        followerAlignment = Alignment.topRight;
        offset = const Offset(20, -20);
        isReceived = true;
        if ((details.globalPosition.dy +
                widget.menuWidgets.length * 40.h +
                88.h) >
            1.sh) {
          targetAlignment = Alignment.topLeft;
          followerAlignment = Alignment.bottomRight;
          offset = const Offset(20, 20);
        }
      }
      if ((details.globalPosition.dy +
              widget.menuWidgets.length * 40.h +
              88.h) >
          1.sh) {
        targetAlignment = Alignment.topLeft;
        followerAlignment = Alignment.bottomRight;
        offset = const Offset(20, 20);
        if ((details.globalPosition.dx + 100.w) < 1.sw) {
          targetAlignment = Alignment.topRight;
          followerAlignment = Alignment.bottomLeft;
          offset = const Offset(-20, 20);
        }
      }
      _overlayEntry = _createOverlayEntry(
        targetAlignment,
        followerAlignment,
        offset,
        isReceived,
      );
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    if (_longPressStartDetails != null) {
      _longPressStartDetails = null;
    }
  }

  /// 创建浮层
  OverlayEntry _createOverlayEntry(
    Alignment targetAlignment,
    Alignment followerAlignment,
    Offset offset,
    bool isReceived,
  ) {
    return OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              // onTap: () {
              //   _hideMenu();
              // },
              behavior: HitTestBehavior.translucent,
              onPanDown: (details) => _hideMenu(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            //UnconstrainedBox
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: targetAlignment,
              followerAnchor: followerAlignment,
              offset: offset,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: isReceived
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Transform.scale(
                            scale: value,
                            child: Opacity(
                              opacity: value,
                              child: ChatLongPressMenu(
                                controller: _controller!,
                                menus: widget.menuWidgets,
                              ),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 6,
                    ),
                    TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Transform.scale(
                            scale: value,
                            child: Opacity(
                              opacity: value,
                              child: const ChatPopupEmoji(),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (details) => _hideMenu(),
      onLongPressStart: (details) => _showMenu(context, details),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: widget.child,
      ),
    );
  }
}
