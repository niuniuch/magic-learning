import 'dart:math';
import 'package:flutter/material.dart';

class RoadBackground extends StatefulWidget {
  final Widget child;

  const RoadBackground({super.key, required this.child});

  @override
  State<RoadBackground> createState() => _RoadBackgroundState();
}

class _RoadBackgroundState extends State<RoadBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_RoadLine> _lines;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    final random = Random();
    _lines = List.generate(25, (_) => _RoadLine(
      x: 0.15 + random.nextDouble() * 0.7,
      phase: random.nextDouble(),
      speed: 2 + random.nextDouble() * 4,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1B1E2E), Color(0xFF252840)],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _RoadLinesPainter(
                lines: _lines,
                animValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _RoadLine {
  final double x;
  final double phase;
  final double speed;

  _RoadLine({required this.x, required this.phase, required this.speed});
}

class _RoadLinesPainter extends CustomPainter {
  final List<_RoadLine> lines;
  final double animValue;

  _RoadLinesPainter({required this.lines, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD740).withValues(alpha: 0.08)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (final line in lines) {
      final y = ((animValue + line.phase) % 1.0) * (size.height + 60) - 60;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(line.x * size.width, y, 4, 40),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RoadLinesPainter oldDelegate) => animValue != oldDelegate.animValue;
}
