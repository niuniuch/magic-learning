import 'dart:math';
import 'package:flutter/material.dart';

class ClockFaceWidget extends StatelessWidget {
  final int hour12; // 1-12
  final double size;

  const ClockFaceWidget({
    super.key,
    required this.hour12,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockFacePainter(hour12: hour12),
      ),
    );
  }
}

class _ClockFacePainter extends CustomPainter {
  final int hour12;

  _ClockFacePainter({required this.hour12});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 4;

    // Outer ring
    canvas.drawCircle(
      Offset(cx, cy),
      r + 4,
      Paint()
        ..color = const Color(0xFF1A1D30)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r + 4,
      Paint()
        ..color = const Color(0xFF3A3F60)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    // Inner circle
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = const Color(0xFF222640)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = const Color(0xFF4A4F70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Tick marks
    for (int i = 0; i < 12; i++) {
      final ang = i * 30 * pi / 180 - pi / 2;
      final isMain = i % 3 == 0;
      final r1 = isMain ? r - 10 : r - 6;
      final r2 = r - 2;
      canvas.drawLine(
        Offset(cx + cos(ang) * r1, cy + sin(ang) * r1),
        Offset(cx + cos(ang) * r2, cy + sin(ang) * r2),
        Paint()
          ..color = const Color(0xFFDDDDDD)
          ..strokeWidth = isMain ? 2.5 : 1.2
          ..strokeCap = StrokeCap.round,
      );
    }

    // Numbers 1-12
    for (int i = 1; i <= 12; i++) {
      final ang = (i * 30 - 90) * pi / 180;
      final nr = r - 18;
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFFC8CCE0),
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(
          cx + cos(ang) * nr - textPainter.width / 2,
          cy + sin(ang) * nr - textPainter.height / 2,
        ),
      );
    }

    // Minute hand at 12
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx, cy - r * 0.7),
      Paint()
        ..color = const Color(0xFF7FAAFF).withValues(alpha: 0.7)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Hour hand
    final hourAngle = ((hour12 % 12) * 30 - 90) * pi / 180;
    final hx = cx + cos(hourAngle) * r * 0.5;
    final hy = cy + sin(hourAngle) * r * 0.5;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(hx, hy),
      Paint()
        ..color = const Color(0xFFFFD740)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Center dot
    canvas.drawCircle(
      Offset(cx, cy),
      4,
      Paint()..color = const Color(0xFFFFD740),
    );
  }

  @override
  bool shouldRepaint(_ClockFacePainter oldDelegate) =>
      hour12 != oldDelegate.hour12;
}
