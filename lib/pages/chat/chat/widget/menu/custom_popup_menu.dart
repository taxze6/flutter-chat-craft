import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

enum PressType {
  longPress,
  singleClick,
}

class CustomPopupMenuController extends ChangeNotifier {
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

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu({
    super.key,
    required this.child,
    required this.menuBuilder,
    required this.pressType,
    this.controller,
    this.arrowColor = Colors.white,
    this.showArrow = true,
    this.barrierColor = Colors.black12,
    this.arrowSize = 10.0,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
  });

  final Widget child;
  final PressType pressType;
  final bool showArrow;
  final Color arrowColor;
  final Color barrierColor;
  final double horizontalMargin;
  final double verticalMargin;
  final double arrowSize;
  final CustomPopupMenuController? controller;
  final Widget Function() menuBuilder;

  @override
  _CustomPopupMenuState createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  CustomPopupMenuController? _controller;

  _showMenu({required LongPressStartDetails details}) {
    Widget arrow = ClipPath(
      clipper: _ArrowClipper(),
      child: Container(
        width: widget.arrowSize,
        height: widget.arrowSize,
        color: widget.arrowColor,
      ),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: <Widget>[
            GestureDetector(
              // onTap: () => _hideMenu(),
              onPanDown: (detail) => _hideMenu(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: widget.barrierColor,
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      _parentBox!.size.width - 2 * widget.horizontalMargin,
                  minWidth: 0,
                ),
                child: CustomMultiChildLayout(
                  delegate: _MenuLayoutDelegate(
                    anchorSize: _childBox!.size,
                    anchorOffset: _childBox!.localToGlobal(
                      Offset(-widget.horizontalMargin, 0),
                    ),
                    verticalMargin: widget.verticalMargin,
                    sizeDetails: details,
                  ),
                  children: <Widget>[
                    if (widget.showArrow)
                      LayoutId(
                        id: _MenuLayoutId.arrow,
                        child: arrow,
                      ),
                    if (widget.showArrow)
                      LayoutId(
                        id: _MenuLayoutId.downArrow,
                        child: Transform.rotate(
                          angle: math.pi,
                          child: arrow,
                        ),
                      ),
                    LayoutId(
                      id: _MenuLayoutId.content,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: widget.menuBuilder(),
                          ),
                        ],
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
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  _updateView() {
    if (_controller?.menuIsShowing ?? false) {
      // _showMenu();
    } else {
      _hideMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller ??= CustomPopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (!mounted) return;
      _childBox = context.findRenderObject() as RenderBox?;
      _parentBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.pressType == PressType.singleClick
            ? () {
                if (widget.pressType == PressType.singleClick) {
                  // _showMenu();
                }
              }
            : null,
        onLongPressStart: (details) {
          _showMenu(details: details);
        },
        // onLongPress: widget.pressType == PressType.longPress
        //     ? () {
        //         if (widget.pressType == PressType.longPress) {
        //           _showMenu();
        //         }
        //       }
        //     : null,
        child: widget.child,
      ),
    );
    if (Platform.isIOS) {
      return child;
    } else {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          _hideMenu();
          return;
        },
        child: child,
      );
    }
  }
}

enum _MenuLayoutId {
  arrow,
  downArrow,
  content,
}

enum _MenuPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  topLeft,
  topCenter,
  topRight,
}

class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.sizeDetails,
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
  });

  final LongPressStartDetails sizeDetails;
  final Size anchorSize;
  final Offset anchorOffset;
  final double verticalMargin;

  @override
  void performLayout(Size size) {
    Size contentSize = Size.zero;
    Size arrowSize = Size.zero;
    Offset contentOffset = const Offset(0, 0);
    Offset arrowOffset = const Offset(0, 0);

    double anchorCenterX = sizeDetails.globalPosition.dx + anchorSize.width / 2;
    double anchorTopY = sizeDetails.globalPosition.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;
    _MenuPosition menuPosition = _MenuPosition.bottomCenter;

    if (hasChild(_MenuLayoutId.content)) {
      contentSize = layoutChild(
        _MenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      arrowSize = layoutChild(
        _MenuLayoutId.arrow,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      layoutChild(
        _MenuLayoutId.downArrow,
        BoxConstraints.loose(size),
      );
    }

    bool isTop = false;
    if (anchorBottomY + verticalMargin + arrowSize.height + contentSize.height >
        size.height) {
      isTop = true;
    }
    if (anchorCenterX - contentSize.width / 2 < 0) {
      menuPosition = isTop ? _MenuPosition.topLeft : _MenuPosition.bottomLeft;
    } else if (anchorCenterX + contentSize.width / 2 > size.width) {
      menuPosition = isTop ? _MenuPosition.topRight : _MenuPosition.bottomRight;
    } else {
      menuPosition =
          isTop ? _MenuPosition.topCenter : _MenuPosition.bottomCenter;
    }

    switch (menuPosition) {
      case _MenuPosition.bottomCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomLeft:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          0,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomRight:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.topCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _MenuPosition.topLeft:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          0,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _MenuPosition.topRight:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
    }
    if (hasChild(_MenuLayoutId.content)) {
      positionChild(_MenuLayoutId.content, contentOffset);
    }
    bool isBottom = false;
    if (_MenuPosition.values.indexOf(menuPosition) < 3) {
      // bottom
      isBottom = true;
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      positionChild(
        _MenuLayoutId.arrow,
        isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy + 0.1)
            : const Offset(-100, 0),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      positionChild(
        _MenuLayoutId.downArrow,
        !isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy - 0.1)
            : const Offset(-100, 0),
      );
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// 模仿PopupMenuButton写的弹窗菜单
class PandaPopupMenu extends StatelessWidget {
  PandaPopupMenu({
    Key? key,
    required this.targetWigdet,
    required this.menuWigdet,
    this.margin,
    this.padding,
    this.color,
    this.width,
    this.height,
    this.decoration,
    this.offset = const Offset(0, 10),
    this.targetAnchor = Alignment.bottomCenter,
    this.followerAnchor = Alignment.topCenter,
  }) : super(key: key);

  final Widget targetWigdet;
  final Widget menuWigdet;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? width;
  final double? height;
  final Decoration? decoration;
  final Offset offset;
  final Alignment targetAnchor;
  final Alignment followerAnchor;

  /// 内部变量
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _showOverlay(context);
      },
      child: Container(
        margin: margin,
        padding: padding,
        color: color,
        width: width,
        height: height,
        decoration: decoration,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: targetWigdet,
        ),
      ),
    );
  }

  /// 显示浮层
  void _showOverlay(BuildContext context) {
    /// 防止重复创建，不然失去句柄的OverlayEntry将无法消除
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  /// 隐藏浮层
  void _hideOverlay() {
    /// 防止null调用异常
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  /// 创建浮层
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            _hideOverlay();
          },
          child: UnconstrainedBox(
            child: CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              offset: const Offset(0, 10),
              child: Material(
                child: menuWigdet,
              ),
            ),
          ),
        );
      },
    );
  }
}

