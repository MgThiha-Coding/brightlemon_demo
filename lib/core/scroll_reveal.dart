import 'package:flutter/material.dart';

/// A widget that reveals its child with a smooth fade + slide-up animation
/// when it is first built (i.e., when it scrolls into the viewport).
///
/// Works great with ScrollablePositionedList which lazily builds items.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset; // in pixels
  final Curve curve;

  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.slideOffset = 40.0,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _currentOpacity = 0.0;
  double _currentOffsetY = 0.0;

  @override
  void initState() {
    super.initState();

    _currentOffsetY = widget.slideOffset;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        final t = widget.curve.transform(_controller.value);
        setState(() {
          _currentOpacity = t.clamp(0.0, 1.0);
          _currentOffsetY = widget.slideOffset * (1.0 - t);
        });
      });

    // Trigger the animation after the optional delay
    if (widget.delay == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.forward();
      });
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _currentOpacity,
      child: Transform.translate(
        offset: Offset(0, _currentOffsetY),
        child: widget.child,
      ),
    );
  }
}
