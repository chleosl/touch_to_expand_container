/// An expandable container that maintains a single/continuous child instance while expanded (in every expanded and collapsed state), which [Overlay] widget in vanilla flutter doesn't and cannot, by placing 'targeter' - [TouchToExpandContainer] widget in wherever specific widget tree you want and rendering real contents in the background 'wrapper' by connecting both using [CompositedTransformTarget] and [CompositedTransformFollower] Widgets. like Hunter-Killer tactics in military term. the [TouchToExpandContainer] sets and receives all the properties and specifics of the Overlay and Conatiner like location, child, decorations, behavior when expanded etc, and [TouchToExpandOverlayWrapper] wrapper 'deploys' or 'renders' it with all the propertes it set and have.

// Huge credit to Claude and Anthropic PBC; I learned Dart and Flutter very fast with the help of Claude, and this code is the result of architecture designed by me, and content/code written by Claude Opus 4 and Me.

// touch_to_expand_container made by @Chleosl

library touch_to_expand_container;

import 'package:flutter/material.dart';

// TODO - the major update roadmap: in 0.2.0, make the isAbsolutePositioned option available.

class CustomHandle {
  final void Function(Canvas canvas, Size size) drawFunction;
  final Size handleSize;
  final bool alwaysRepaint;

  const CustomHandle({
    required this.drawFunction,
    required this.handleSize,
    this.alwaysRepaint = true,
  });
}

class CustomHandlePainter extends CustomPainter {
  final void Function(Canvas canvas, Size size) drawFunction;
  final bool _shouldRepaint;

  CustomHandlePainter(this.drawFunction, this._shouldRepaint);

  @override
  void paint(Canvas canvas, Size size) {
    drawFunction(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => _shouldRepaint;
}

/// CustomClipper that 'prunes' z-index using ClipPath with an inverse rectangle cutout
class InverseRectClipper extends CustomClipper<Path> {
  final Rect cutoutRect;
  final double opacity;

  InverseRectClipper(this.cutoutRect, this.opacity);

  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
          ..addRect(cutoutRect)
          ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(InverseRectClipper oldClipper) {
    return cutoutRect != oldClipper.cutoutRect || opacity != oldClipper.opacity;
  }
}

/// InheritedWidget to provide expansion state to child widgets
class ExpandedStateProvider extends InheritedWidget {
  final bool isExpanded;
  final double animationValue;
  final double currentWidth;
  final double currentHeight;

  const ExpandedStateProvider({
    super.key,
    required this.isExpanded,
    required this.animationValue,
    required this.currentWidth,
    required this.currentHeight,
    required super.child,
  });

  static ExpandedStateProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ExpandedStateProvider>();
  }

  @override
  bool updateShouldNotify(ExpandedStateProvider oldWidget) {
    return isExpanded != oldWidget.isExpanded ||
        animationValue != oldWidget.animationValue ||
        currentWidth != oldWidget.currentWidth ||
        currentHeight != oldWidget.currentHeight;
  }
}

/// Internal data provider for TouchToExpandContainer system
class TouchToExpandData extends InheritedWidget {
  final TouchToExpandOverlayState state;

  const TouchToExpandData({
    super.key,
    required this.state,
    required super.child,
  });

  static TouchToExpandOverlayState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TouchToExpandData>()
        ?.state;
  }

  @override
  bool updateShouldNotify(TouchToExpandData oldWidget) {
    return state != oldWidget.state;
  }
}

/// A wrapper widget that manages the expand/collapse functionality for all TouchToExpandContainer widgets
class TouchToExpandOverlayWrapper extends StatefulWidget {
  final Widget child;

  const TouchToExpandOverlayWrapper({super.key, required this.child});

  @override
  TouchToExpandOverlayState createState() => TouchToExpandOverlayState();
}

class TouchToExpandOverlayState extends State<TouchToExpandOverlayWrapper>
    with TickerProviderStateMixin {
  final Map<Key, TouchToExpandTargetData> _targets = {};
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0.0);

  Key? _expandedTargetKey;
  AnimationController? _animationController;
  Animation<double>? _animation;

  bool _isDraggingHandle = false;

  void registerTarget(Key key, TouchToExpandTargetData data) {
    setState(() {
      _targets[key] = data;
    });
  }

  void unregisterTarget(Key key) {
    setState(() {
      _targets.remove(key);
      if (_expandedTargetKey == key) {
        collapse();
      }
    });
  }

  void updateTarget(Key key, TouchToExpandTargetData data) {
    if (_targets.containsKey(key)) {
      setState(() {
        _targets[key] = data;
      });
    }
  }

  void expand(Key targetKey) {
    if (!_targets.containsKey(targetKey)) return;

    final targetData = _targets[targetKey]!;
    final targetContext = targetData.targetContext;

    if (targetContext != null && targetContext.mounted) {
      setState(() {
        _expandedTargetKey = targetKey;

        final updatedTargets = <Key, TouchToExpandTargetData>{};
        for (final entry in _targets.entries) {
          final key = entry.key;
          final data = entry.value;
          final context = data.targetContext;

          if (context != null && context.mounted) {
            final renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);

            updatedTargets[key] = TouchToExpandTargetData(
              link: data.link,
              child: data.child,
              width: data.width,
              height: data.height,
              expandedWidth: data.expandedWidth,
              expandedHeight: data.expandedHeight,
              duration: data.duration,
              animationCurve: data.animationCurve,
              reverseAnimationCurve: data.reverseAnimationCurve,
              decoration: data.decoration,
              expandedDecoration: data.expandedDecoration,
              expandedOffset: data.expandedOffset,
              position: position,
              targetContext: context,
              isLiveAlways: data.isLiveAlways,
              isHandled: data.isHandled,
              customHandlePainter: data.customHandlePainter,
              handlebarOffset: data.handlebarOffset,
              showBarrier: data.showBarrier,
              barrierColor: data.barrierColor,
              isScrollActivated: data.isScrollActivated,
              isAbsolutePositioned: data.isAbsolutePositioned,
            );
          } else {
            updatedTargets[key] = data;
          }
        }
        _targets.clear();
        _targets.addAll(updatedTargets);

        _animationController?.dispose();
        _animationController = AnimationController(
          duration: targetData.duration,
          vsync: this,
        );

        _animation = CurvedAnimation(
          parent: _animationController!,
          curve: targetData.animationCurve,
          reverseCurve: targetData.reverseAnimationCurve,
        );

        _animationController!.forward();
      });
    }
  }

  void collapse() {
    if (_animationController != null) {
      _animationController!.reverse().then((_) {
        setState(() {
          _expandedTargetKey = null;
          _animationController?.dispose();
          _animationController = null;
          _animation = null;
        });
      });
    }
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    if (_expandedTargetKey == null || !_isDraggingHandle) return;

    final targetData = _targets[_expandedTargetKey!];
    if (targetData == null) return;

    final newOffset = targetData.expandedOffset + details.delta;

    setState(() {
      _targets[_expandedTargetKey!] = TouchToExpandTargetData(
        link: targetData.link,
        child: targetData.child,
        width: targetData.width,
        height: targetData.height,
        expandedWidth: targetData.expandedWidth,
        expandedHeight: targetData.expandedHeight,
        duration: targetData.duration,
        animationCurve: targetData.animationCurve,
        reverseAnimationCurve: targetData.reverseAnimationCurve,
        decoration: targetData.decoration,
        expandedDecoration: targetData.expandedDecoration,
        expandedOffset: newOffset,
        position: targetData.position,
        targetContext: targetData.targetContext,
        isLiveAlways: targetData.isLiveAlways,
        isHandled: targetData.isHandled,
        customHandlePainter: targetData.customHandlePainter,
        handlebarOffset: targetData.handlebarOffset,
        showBarrier: targetData.showBarrier,
        barrierColor: targetData.barrierColor,
        isScrollActivated: targetData.isScrollActivated,
        isAbsolutePositioned: targetData.isAbsolutePositioned,
      );
    });
  }

  void _defaultDrawFunction(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color.fromARGB(255, 199, 199, 199)
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(8, 0)
          ..lineTo(size.width - 8, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    canvas.drawPath(path, paint);

    final gripPaint =
        Paint()
          ..color = const Color(0xFF4A5568)
          ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 3; i++) {
      final x = centerX + (i - 1) * 6;
      canvas.drawCircle(Offset(x, centerY + 1), 1.5, gripPaint);
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  bool _checkOverlap(
    TouchToExpandTargetData expandedData,
    TouchToExpandTargetData currentData,
    double animationValue,
  ) {
    final screenSize = MediaQuery.of(context).size;

    final expandedWidth =
        expandedData.width +
        (expandedData.expandedWidth - expandedData.width) * animationValue;
    final expandedHeight =
        expandedData.height +
        (expandedData.expandedHeight - expandedData.height) * animationValue;

    final expandedCenter = Offset(
      (screenSize.width - expandedData.expandedWidth) / 2,
      (screenSize.height - expandedData.expandedHeight) / 2,
    );

    final expandedOffset = Offset(
      expandedCenter.dx -
          expandedData.position.dx +
          (expandedData.position.dx - expandedCenter.dx) *
              (1 - animationValue) +
          expandedData.expandedOffset.dx * animationValue,
      expandedCenter.dy -
          expandedData.position.dy +
          (expandedData.position.dy - expandedCenter.dy) *
              (1 - animationValue) +
          expandedData.expandedOffset.dy * animationValue,
    );

    final expandedRect = Rect.fromLTWH(
      expandedData.position.dx + expandedOffset.dx,
      expandedData.position.dy + expandedOffset.dy,
      expandedWidth,
      expandedHeight,
    );

    final currentRect = Rect.fromLTWH(
      currentData.position.dx,
      currentData.position.dy,
      currentData.width,
      currentData.height,
    );

    return expandedRect.overlaps(currentRect);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      // in-development feature to fix the container position in absolute location on screen in scrollable background.
      onNotification: (notification) {
        if (_expandedTargetKey != null) {
          final expandedData = _targets[_expandedTargetKey!];
          if (expandedData != null && expandedData.isScrollActivated) {
            _scrollOffset.value = notification.metrics.pixels;
          }
        }
        return false;
      },
      child: TouchToExpandData(
        state: this,
        child: Stack(
          children: [
            widget.child,

            if (_expandedTargetKey != null && _animation != null)
              Builder(
                builder: (context) {
                  final expandedData = _targets[_expandedTargetKey!];
                  if (expandedData == null || !expandedData.showBarrier) {
                    return const SizedBox.shrink();
                  }
                  // a screen-sized barrier that blocks and dim the screen
                  return AnimatedBuilder(
                    animation: _animation!,
                    builder: (context, child) {
                      return Positioned.fill(
                        child: IgnorePointer(
                          ignoring: _animation!.value < 0.1,
                          child: GestureDetector(
                            onTap: collapse,
                            onVerticalDragUpdate:
                                expandedData.isScrollActivated ? null : (_) {},
                            onHorizontalDragUpdate:
                                expandedData.isScrollActivated ? null : (_) {},
                            behavior:
                                expandedData.isScrollActivated
                                    ? HitTestBehavior.translucent
                                    : HitTestBehavior.opaque,

                            child: Container(
                              color: expandedData.barrierColor.withValues(
                                alpha:
                                    expandedData.barrierColor.a *
                                    _animation!.value,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

            // a Clip-applied renderer for child and container
            ..._targets.entries.map((entry) {
              final key = entry.key;
              final data = entry.value;
              final isExpanded = key == _expandedTargetKey;

              return CompositedTransformFollower(
                key: key,
                link: data.link,
                showWhenUnlinked: false,
                child: AnimatedBuilder(
                  animation: _animation ?? kAlwaysDismissedAnimation,
                  builder: (context, child) {
                    final animValue =
                        isExpanded && _animation != null
                            ? _animation!.value
                            : 0.0;

                    double overlayOpacity = 0.0;
                    if (_expandedTargetKey != null && !isExpanded) {
                      final expandedData = _targets[_expandedTargetKey];
                      if (expandedData != null) {
                        final isOverlapping = _checkOverlap(
                          expandedData,
                          data,
                          _animation?.value ?? 0.0,
                        );
                        if (isOverlapping) {
                          overlayOpacity = _animation?.value ?? 0.0;
                        }
                      }
                    }

                    final screenSize = MediaQuery.of(context).size;

                    final currentWidth =
                        data.width +
                        (data.expandedWidth - data.width) * animValue;
                    final currentHeight =
                        data.height +
                        (data.expandedHeight - data.height) * animValue;

                    final expandedCenter = Offset(
                      (screenSize.width - data.expandedWidth) / 2 -
                          data.position.dx,
                      (screenSize.height - data.expandedHeight) / 2 -
                          data.position.dy,
                    );

                    final offset = Offset(
                      expandedCenter.dx * animValue +
                          data.expandedOffset.dx * animValue,
                      expandedCenter.dy * animValue +
                          data.expandedOffset.dy * animValue,
                    );

                    Rect? overlapRect;
                    if (overlayOpacity > 0 && _expandedTargetKey != null) {
                      final expandedData = _targets[_expandedTargetKey];
                      if (expandedData != null) {
                        final expandedWidth =
                            expandedData.width +
                            (expandedData.expandedWidth - expandedData.width) *
                                (_animation?.value ?? 0);
                        final expandedHeight =
                            expandedData.height +
                            (expandedData.expandedHeight -
                                    expandedData.height) *
                                (_animation?.value ?? 0);

                        final expandedCenter = Offset(
                          (screenSize.width - expandedData.expandedWidth) / 2,
                          (screenSize.height - expandedData.expandedHeight) / 2,
                        );

                        final expandedOffset = Offset(
                          expandedCenter.dx -
                              expandedData.position.dx +
                              (expandedData.position.dx - expandedCenter.dx) *
                                  (1 - (_animation?.value ?? 0)) +
                              expandedData.expandedOffset.dx *
                                  (_animation?.value ?? 0),
                          expandedCenter.dy -
                              expandedData.position.dy +
                              (expandedData.position.dy - expandedCenter.dy) *
                                  (1 - (_animation?.value ?? 0)) +
                              expandedData.expandedOffset.dy *
                                  (_animation?.value ?? 0),
                        );

                        final expandedRect = Rect.fromLTWH(
                          expandedData.position.dx + expandedOffset.dx,
                          expandedData.position.dy + expandedOffset.dy,
                          expandedWidth,
                          expandedHeight,
                        );

                        final currentRect = Rect.fromLTWH(
                          data.position.dx,
                          data.position.dy,
                          data.width,
                          data.height,
                        );

                        if (expandedRect.overlaps(currentRect)) {
                          overlapRect = expandedRect.intersect(currentRect);
                          overlapRect = overlapRect.translate(
                            -data.position.dx,
                            -data.position.dy,
                          );
                        }
                      }
                    }

                    Widget containerWidget = Stack(
                      children: [
                        Container(
                          width: currentWidth,
                          height: currentHeight,
                          decoration:
                              animValue > 0.1
                                  ? (data.expandedDecoration ??
                                      _defaultExpandedDecoration)
                                  : (data.decoration ?? _defaultDecoration),
                          clipBehavior: Clip.antiAlias,
                          child: ExpandedStateProvider(
                            isExpanded: animValue > 0.5,
                            animationValue: animValue,
                            currentWidth: currentWidth,
                            currentHeight: currentHeight,
                            child: data.child,
                          ),
                        ),
                        if (_expandedTargetKey != null &&
                            !isExpanded &&
                            !data.isLiveAlways)
                          Builder(
                            builder: (context) {
                              final expandedData = _targets[_expandedTargetKey];
                              if (expandedData == null ||
                                  !expandedData.showBarrier) {
                                return const SizedBox.shrink();
                              }
                              // a 'personalized' barrier for each container screen, to responsively block the contents while in complex Z-index situations.
                              return Positioned.fill(
                                child: AnimatedBuilder(
                                  animation: _animation!,
                                  builder: (context, child) {
                                    return GestureDetector(
                                      onVerticalDragUpdate:
                                          expandedData.isScrollActivated
                                              ? null
                                              : (_) {},
                                      onHorizontalDragUpdate:
                                          expandedData.isScrollActivated
                                              ? null
                                              : (_) {},
                                      onTap: collapse,
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: currentWidth,
                                        height: currentHeight,
                                        color: expandedData.barrierColor
                                            .withValues(
                                              alpha:
                                                  expandedData.barrierColor.a *
                                                  (_animation?.value ?? 0.0),
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                      ],
                    );

                    containerWidget = ClipPath(
                      clipper:
                          (overlapRect != null && overlayOpacity > 0)
                              ? InverseRectClipper(overlapRect, overlayOpacity)
                              : null,
                      child: containerWidget,
                    );

                    // an actual child and container for [TouchToExpandContainer]
                    return Transform.translate(
                      offset: offset,
                      child: GestureDetector(
                        onTap: () {
                          if (isExpanded) {
                            collapse();
                          } else {
                            expand(key);
                          }
                        },
                        child: containerWidget,
                      ),
                    );
                  },
                ),
              );
            }),

            if (_expandedTargetKey != null && _animation != null)
              Builder(
                builder: (context) {
                  final expandedData = _targets[_expandedTargetKey!];
                  if (expandedData == null || !expandedData.isHandled) {
                    return const SizedBox.shrink();
                  }
                  // handle renderer when [isHandled] is true
                  return CompositedTransformFollower(
                    link: expandedData.link,
                    showWhenUnlinked: false,
                    child: AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        final animValue = _animation!.value;
                        if (animValue < 0.5) return const SizedBox.shrink();

                        final screenSize = MediaQuery.of(context).size;

                        final expandedCenter = Offset(
                          (screenSize.width - expandedData.expandedWidth) / 2 -
                              expandedData.position.dx,
                          (screenSize.height - expandedData.expandedHeight) /
                                  2 -
                              expandedData.position.dy,
                        );

                        final handle =
                            expandedData.customHandlePainter ??
                            CustomHandle(
                              drawFunction: _defaultDrawFunction,
                              handleSize: const Size(60, 28),
                              alwaysRepaint: true,
                            );

                        final offset = Offset(
                          expandedCenter.dx * animValue +
                              expandedData.expandedOffset.dx * animValue +
                              expandedData.handlebarOffset.dx,
                          expandedCenter.dy * animValue +
                              expandedData.expandedOffset.dy * animValue -
                              handle.handleSize.height +
                              expandedData.handlebarOffset.dy,
                        );

                        return Transform.translate(
                          offset: offset,
                          child: CustomPaint(
                            painter: CustomHandlePainter(
                              handle.drawFunction,
                              handle.alwaysRepaint,
                            ),
                            child: GestureDetector(
                              onVerticalDragStart: (_) {},
                              onVerticalDragUpdate: (_) {},
                              onHorizontalDragStart: (_) {},
                              onHorizontalDragUpdate: (_) {},
                              behavior: HitTestBehavior.opaque,
                              child: Listener(
                                behavior: HitTestBehavior.opaque,
                                onPointerDown: (event) {
                                  _isDraggingHandle = true;
                                },
                                onPointerMove: (event) {
                                  if (_isDraggingHandle) {
                                    _onHandleDragUpdate(
                                      DragUpdateDetails(
                                        globalPosition: event.position,
                                        delta: event.delta,
                                        localPosition: event.localPosition,
                                      ),
                                    );
                                  }
                                },
                                onPointerUp: (event) {
                                  _isDraggingHandle = false;
                                },
                                child: SizedBox(
                                  width: handle.handleSize.width,
                                  height: handle.handleSize.height,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration get _defaultDecoration => BoxDecoration(
    border: Border.all(color: Colors.black, width: 1.5),
    borderRadius: BorderRadius.circular(2),
  );

  BoxDecoration get _defaultExpandedDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(2),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
    border: Border.all(color: Colors.black, width: 2),
  );
}

/// Data model for TouchToExpandContainer targets
class TouchToExpandTargetData {
  final LayerLink link;
  final Widget child;
  final double width;
  final double height;
  final double expandedWidth;
  final double expandedHeight;
  final Duration duration;
  final Curve animationCurve;
  final Curve reverseAnimationCurve;
  final BoxDecoration? decoration;
  final BoxDecoration? expandedDecoration;
  final Offset expandedOffset;
  final Offset position;
  final BuildContext? targetContext;
  final bool isLiveAlways;
  final bool isHandled;
  final CustomHandle? customHandlePainter;
  final Offset handlebarOffset;
  final bool showBarrier;
  final Color barrierColor;
  final bool isScrollActivated;
  final bool isAbsolutePositioned;

  TouchToExpandTargetData({
    required this.link,
    required this.child,
    required this.width,
    required this.height,
    required this.expandedWidth,
    required this.expandedHeight,
    required this.duration,
    required this.animationCurve,
    required this.reverseAnimationCurve,
    Offset? expandedOffset,
    required this.position,
    this.decoration,
    this.expandedDecoration,
    this.targetContext,
    required this.isLiveAlways,
    required this.isHandled,
    this.customHandlePainter,
    this.handlebarOffset = Offset.zero,
    required this.showBarrier,
    required this.barrierColor,
    required this.isScrollActivated,
    required this.isAbsolutePositioned,
  }) : expandedOffset = expandedOffset ?? Offset.zero;
}

/// A container Widget that is maintaining a single widget child instance and expands to fill the screen when tapped
class TouchToExpandContainer extends StatefulWidget {
  /// The widget to display inside the container
  final Widget child;

  /// width of the container
  final double width;

  /// height of the container
  final double height;

  /// Width when expanded (defaults to (screenSize.width > 800 ? 700.0 : screenSize.width * 0.82))
  final double? expandedWidth;

  /// Height when expanded (defaults to 55% of screen height)
  final double? expandedHeight;

  /// Duration of the expand/collapse animation
  final Duration duration;

  /// Curve for the expand animation
  final Curve animationCurve;

  /// Curve for the collapse animation
  final Curve reverseAnimationCurve;

  /// Decoration for the container (defaults to 1.5px black border)
  final BoxDecoration? decoration;

  /// Decoration for the expanded container (defaults to 1.5px black border and a little shadow effect)
  final BoxDecoration? expandedDecoration;

  /// Whether to display the container box decoration/outline in collapsed location in expanded state
  final bool isOutlineDisplayed;

  /// offset to apply when expanded
  final Offset expandedOffset;

  /// Whether this container should ignore barrier effects from other containers
  final bool isLiveAlways;

  /// Whether to show a drag handle when expanded
  final bool isHandled;

  /// A drawable custom handle drawer that receives [CustomPainter.paint] function and [Size].
  final CustomHandle? customHandlePainter;

  /// Offset for the handle position relative to the expanded container location
  final Offset handlebarOffset;

  /// Whether to show the modal barrier when expanded
  final bool showBarrier;

  /// The color of the modal barrier that appears behind expanded containers
  final Color barrierColor;

  /// Whether this container should maintain absolute position during scroll; not implemented yet in 0.1.0
  final bool isAbsolutePositioned;

  /// Whether scrolling the background is allowed when this container is expanded
  final bool isScrollActivated;

  const TouchToExpandContainer({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.expandedWidth,
    this.expandedHeight,
    this.duration = const Duration(milliseconds: 290),
    this.animationCurve = const Cubic(0.2, 0.1, 0.4, 1.0),
    this.reverseAnimationCurve = const Cubic(0.45, 0, 0.75, 0),
    this.decoration,
    this.expandedDecoration,
    this.isOutlineDisplayed = true,
    this.expandedOffset = Offset.zero,
    this.isLiveAlways = false,
    this.isHandled = false,
    this.customHandlePainter,
    this.handlebarOffset = Offset.zero,
    this.showBarrier = true,
    this.barrierColor = const Color.fromARGB(47, 0, 0, 0),
    this.isAbsolutePositioned = true,
    this.isScrollActivated = false,
  });

  @override
  State<TouchToExpandContainer> createState() => TouchToExpandContainerState();
}

class TouchToExpandContainerState extends State<TouchToExpandContainer> {
  final LayerLink _layerLink = LayerLink();
  late final GlobalKey _key = GlobalKey();
  TouchToExpandOverlayState? _overlayState;

  bool get isExpanded => _overlayState?._expandedTargetKey == _key;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTargetData();
    });
  }

  void expand() {
    _overlayState?.expand(_key);
  }

  void collapse() {
    _overlayState?.collapse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _overlayState = TouchToExpandData.of(context);
  }

  @override
  void didUpdateWidget(TouchToExpandContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTargetData();
    });
  }

  void _updateTargetData() {
    if (_overlayState == null) return;

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final position = box.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final data = TouchToExpandTargetData(
      link: _layerLink,
      child: widget.child,
      width: widget.width,
      height: widget.height,
      expandedWidth:
          widget.expandedWidth ??
          (screenSize.width > 800 ? 700.0 : screenSize.width * 0.82),
      expandedHeight: widget.expandedHeight ?? screenSize.height * 0.55,
      duration: widget.duration,
      animationCurve: widget.animationCurve,
      reverseAnimationCurve: widget.reverseAnimationCurve,
      decoration: widget.decoration,
      expandedDecoration: widget.expandedDecoration,
      expandedOffset: widget.expandedOffset,
      position: position,
      targetContext: context,
      isLiveAlways: widget.isLiveAlways,
      isHandled: widget.isHandled,
      customHandlePainter: widget.customHandlePainter,
      handlebarOffset: widget.handlebarOffset,
      showBarrier: widget.showBarrier,
      barrierColor: widget.barrierColor,
      isScrollActivated: widget.isScrollActivated,
      isAbsolutePositioned: widget.isAbsolutePositioned,
    );

    if (_overlayState!._targets.containsKey(_key)) {
      _overlayState!.updateTarget(_key, data);
    } else {
      _overlayState!.registerTarget(_key, data);
    }
  }

  @override
  void dispose() {
    _overlayState?.unregisterTarget(_key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration:
            widget.isOutlineDisplayed
                ? (widget.decoration ??
                    BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                    ))
                : const BoxDecoration(),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
