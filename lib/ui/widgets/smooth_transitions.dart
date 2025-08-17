import 'package:flutter/material.dart';

/// Utility class for creating smooth transitions between UI sections
class SmoothTransitions {
  /// Creates a smooth fade transition for content changes
  static Widget fadeTransition({
    required Widget child,
    required bool show,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Creates a smooth slide transition for content changes
  static Widget slideTransition({
    required Widget child,
    required bool show,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset beginOffset = const Offset(0.0, 0.3),
    Offset endOffset = Offset.zero,
  }) {
    return AnimatedSlide(
      offset: show ? endOffset : beginOffset,
      duration: duration,
      curve: curve,
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  /// Creates a smooth scale transition for content changes
  static Widget scaleTransition({
    required Widget child,
    required bool show,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double beginScale = 0.8,
    double endScale = 1.0,
  }) {
    return AnimatedScale(
      scale: show ? endScale : beginScale,
      duration: duration,
      curve: curve,
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  /// Creates a smooth container transition for size and color changes
  static Widget containerTransition({
    required Widget child,
    required bool expanded,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Color? expandedColor,
    Color? collapsedColor,
    EdgeInsetsGeometry? expandedPadding,
    EdgeInsetsGeometry? collapsedPadding,
    BorderRadius? expandedBorderRadius,
    BorderRadius? collapsedBorderRadius,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: expanded ? expandedPadding : collapsedPadding,
      decoration: BoxDecoration(
        color: expanded ? expandedColor : collapsedColor,
        borderRadius: expanded ? expandedBorderRadius : collapsedBorderRadius,
      ),
      child: child,
    );
  }

  /// Creates a smooth switcher transition for changing between different widgets
  static Widget switcherTransition({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: transitionBuilder ?? _defaultTransitionBuilder,
      child: child,
    );
  }

  /// Creates a smooth list transition for adding/removing items
  static Widget listTransition({
    required Widget child,
    required Animation<double> animation,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Creates a smooth page transition for navigation
  static PageRouteBuilder<T> pageTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    PageTransitionType type = PageTransitionType.slideFromRight,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (type) {
          case PageTransitionType.slideFromRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          case PageTransitionType.slideFromBottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          case PageTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case PageTransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
        }
      },
    );
  }

  /// Default transition builder for AnimatedSwitcher
  static Widget _defaultTransitionBuilder(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
    );
  }
}

/// Enum for different page transition types
enum PageTransitionType {
  slideFromRight,
  slideFromBottom,
  fade,
  scale,
}

/// Widget that provides smooth transitions for its child when it changes
class SmoothTransitionWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const SmoothTransitionWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<SmoothTransitionWrapper> createState() => _SmoothTransitionWrapperState();
}

class _SmoothTransitionWrapperState extends State<SmoothTransitionWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(SmoothTransitionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child.runtimeType != widget.child.runtimeType) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(_animation),
            child: widget.child,
          ),
        );
      },
    );
  }
}