import 'package:flutter/material.dart';

class CircleAnimationWidget extends StatefulWidget {
  final Widget child;
  const CircleAnimationWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<CircleAnimationWidget> createState() => _CircleAnimationWidgetState();
}

class _CircleAnimationWidgetState extends State<CircleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..forward()
      ..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
}
