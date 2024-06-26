import 'dart:math';
import 'package:flutter/material.dart';

class StrangeOptimizedCircularProgressIndicator extends StatefulWidget {
  final Color? color;
  final double strokeWidth;

  const StrangeOptimizedCircularProgressIndicator({super.key, this.color, this.strokeWidth = 4});

  @override
  State<StrangeOptimizedCircularProgressIndicator> createState() => _StrangeOptimizedCircularProgressIndicatorState();
}

class _StrangeOptimizedCircularProgressIndicatorState extends State<StrangeOptimizedCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var circularTheme = Theme.of(context).progressIndicatorTheme;

    return Center(
      child: LayoutBuilder(builder: (context, constrains) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: StrangeOptimizedCircularProgressIndicatorPainter(
                  animationValue: _animation.value,
                  color: widget.color ?? circularTheme.color ?? Theme.of(context).colorScheme.primary,
                  strokeWidth: widget.strokeWidth),
              size: Size(constrains.maxHeight, constrains.maxHeight),
            );
          },
        );
      }),
    );
  }
}

class StrangeOptimizedCircularProgressIndicatorPainter extends CustomPainter {
  StrangeOptimizedCircularProgressIndicatorPainter(
      {super.repaint, required this.animationValue, required this.color, required this.strokeWidth});

  final double animationValue;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final start = sin(animationValue * 2 * pi) * pi;
    final end = cos(animationValue * 2 * pi) * pi;

    final center = Offset(size.width / 2, size.height / 2);

    final rect = Rect.fromCircle(center: center, radius: size.width / 2);
    canvas.drawArc(rect, start, end, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
