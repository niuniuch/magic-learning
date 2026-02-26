import 'dart:math';
import 'package:flutter/material.dart';

class SpaceBackground extends StatefulWidget {
  final Widget child;

  const SpaceBackground({super.key, required this.child});

  @override
  State<SpaceBackground> createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<SpaceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    final random = Random();
    _stars = List.generate(70, (_) => _Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: 2 + random.nextDouble() * 3,
      phase: random.nextDouble(),
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
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B0E1A), Color(0xFF141830)],
            ),
          ),
        ),
        // Stars
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _StarsPainter(
                stars: _stars,
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

class _Star {
  final double x;
  final double y;
  final double size;
  final double phase;

  _Star({required this.x, required this.y, required this.size, required this.phase});
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double animValue;

  _StarsPainter({required this.stars, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final opacity = 0.15 + 0.85 * ((sin((animValue + star.phase) * pi * 2) + 1) / 2);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size / 2,
        Paint()..color = Colors.white.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) => animValue != oldDelegate.animValue;
}
