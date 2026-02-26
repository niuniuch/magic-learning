import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  final bool trigger;
  final int particleCount;

  const ConfettiOverlay({
    super.key,
    required this.trigger,
    this.particleCount = 30,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  static const _colors = [
    Color(0xFFFFC947),
    Color(0xFFE94560),
    Color(0xFF2ECC71),
    Color(0xFF845EF7),
    Color(0xFF00B4D8),
    Color(0xFFFF6B6B),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _spawn();
    }
  }

  void _spawn() {
    _particles = List.generate(widget.particleCount, (_) {
      return _ConfettiParticle(
        x: _random.nextDouble(),
        speed: 1.5 + _random.nextDouble() * 2,
        size: 6 + _random.nextDouble() * 8,
        color: _colors[_random.nextInt(_colors.length)],
        isCircle: _random.nextBool(),
        delay: _random.nextDouble() * 0.5,
      );
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (!_controller.isAnimating && _controller.value == 0) {
          return const SizedBox.shrink();
        }
        return IgnorePointer(
          child: CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double speed;
  final double size;
  final Color color;
  final bool isCircle;
  final double delay;

  _ConfettiParticle({
    required this.x,
    required this.speed,
    required this.size,
    required this.color,
    required this.isCircle,
    required this.delay,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress - p.delay).clamp(0.0, 1.0) / (1.0 - p.delay).clamp(0.01, 1.0);
      if (t <= 0) continue;

      final opacity = (1 - t).clamp(0.0, 1.0);
      final y = -10 + t * (size.height + 20) * p.speed / 2;
      final x = p.x * size.width;
      final rotation = t * 4 * pi;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      final paint = Paint()..color = p.color.withValues(alpha: opacity);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => progress != oldDelegate.progress;
}
