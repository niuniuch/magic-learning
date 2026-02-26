import 'dart:math';
import 'package:flutter/material.dart';

class CarPainter extends CustomPainter {
  final int builtParts;
  final Map<String, Color> colorScheme;

  CarPainter({
    required this.builtParts,
    required this.colorScheme,
  });

  Color get _body => colorScheme['body'] ?? const Color(0xFFE74C3C);
  Color get _body2 => colorScheme['body2'] ?? const Color(0xFFC0392B);
  Color get _wing => colorScheme['wing'] ?? const Color(0xFFC0392B);
  Color get _window => colorScheme['window'] ?? const Color(0xFF5DADE2);
  Color get _wheel => colorScheme['wheel'] ?? const Color(0xFF333333);
  Color get _rim => colorScheme['rim'] ?? const Color(0xFF888888);
  Color get _stripe => colorScheme['stripe'] ?? const Color(0xFFFFD740);
  Color get _accent => colorScheme['accent'] ?? const Color(0xFFFF6B6B);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 120;
    final sy = size.height / 260;

    _drawGhost(canvas, sx, sy);

    if (builtParts >= 1) _drawMainBody(canvas, sx, sy);
    if (builtParts >= 2) _drawNoseCone(canvas, sx, sy);
    if (builtParts >= 3) _drawCockpit(canvas, sx, sy);
    if (builtParts >= 4) _drawRearWing(canvas, sx, sy);
    if (builtParts >= 5) _drawLeftRearWheel(canvas, sx, sy);
    if (builtParts >= 6) _drawRightRearWheel(canvas, sx, sy);
    if (builtParts >= 7) _drawLeftFrontWheel(canvas, sx, sy);
    if (builtParts >= 8) _drawRightFrontWheel(canvas, sx, sy);
    if (builtParts >= 9) _drawStripes(canvas, sx, sy);
    if (builtParts >= 10) _drawExhaust(canvas, sx, sy);
  }

  void _drawGhost(Canvas canvas, double sx, double sy) {
    final ghostPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    // Ghost body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30 * sx, 30 * sy, 60 * sx, 170 * sy),
        Radius.circular(20 * min(sx, sy)),
      ),
      ghostPaint,
    );
    // Ghost rear wheels
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15 * sx, 160 * sy, 20 * sx, 45 * sy),
        Radius.circular(8 * min(sx, sy)),
      ),
      ghostPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(85 * sx, 160 * sy, 20 * sx, 45 * sy),
        Radius.circular(8 * min(sx, sy)),
      ),
      ghostPaint,
    );
    // Ghost front wheels
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18 * sx, 42 * sy, 18 * sx, 35 * sy),
        Radius.circular(7 * min(sx, sy)),
      ),
      ghostPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(84 * sx, 42 * sy, 18 * sx, 35 * sy),
        Radius.circular(7 * min(sx, sy)),
      ),
      ghostPaint,
    );
  }

  void _drawMainBody(Canvas canvas, double sx, double sy) {
    final bodyPaint = Paint()..color = _body;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30 * sx, 30 * sy, 60 * sx, 170 * sy),
        Radius.circular(20 * min(sx, sy)),
      ),
      bodyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30 * sx, 30 * sy, 60 * sx, 170 * sy),
        Radius.circular(20 * min(sx, sy)),
      ),
      Paint()
        ..color = _body2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * min(sx, sy),
    );
    // Detail lines
    final linePaint = Paint()
      ..color = _body2.withValues(alpha: 0.4)
      ..strokeWidth = 0.7 * min(sx, sy);
    canvas.drawLine(Offset(40 * sx, 50 * sy), Offset(40 * sx, 180 * sy), linePaint);
    canvas.drawLine(Offset(80 * sx, 50 * sy), Offset(80 * sx, 180 * sy), linePaint);
  }

  void _drawNoseCone(Canvas canvas, double sx, double sy) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 32 * sy), width: 44 * sx, height: 32 * sy),
      Paint()..color = _body2,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 28 * sy), width: 16 * sx, height: 12 * sy),
      Paint()..color = _accent.withValues(alpha: 0.3),
    );
  }

  void _drawCockpit(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(42 * sx, 85 * sy, 36 * sx, 40 * sy),
        Radius.circular(10 * min(sx, sy)),
      ),
      Paint()..color = const Color(0xFF111111),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(42 * sx, 85 * sy, 36 * sx, 40 * sy),
        Radius.circular(10 * min(sx, sy)),
      ),
      Paint()
        ..color = _window
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * min(sx, sy),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(47 * sx, 90 * sy, 26 * sx, 28 * sy),
        Radius.circular(7 * min(sx, sy)),
      ),
      Paint()..color = _window.withValues(alpha: 0.6),
    );
    // Highlight
    canvas.drawOval(
      Rect.fromCenter(center: Offset(55 * sx, 98 * sy), width: 12 * sx, height: 8 * sy),
      Paint()..color = Colors.white.withValues(alpha: 0.2),
    );
  }

  void _drawRearWing(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(22 * sx, 195 * sy, 76 * sx, 10 * sy),
        Radius.circular(3 * min(sx, sy)),
      ),
      Paint()..color = _wing,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18 * sx, 190 * sy, 84 * sx, 8 * sy),
        Radius.circular(3 * min(sx, sy)),
      ),
      Paint()..color = _body2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(35 * sx, 185 * sy, 50 * sx, 6 * sy),
        Radius.circular(2 * min(sx, sy)),
      ),
      Paint()..color = _wing.withValues(alpha: 0.7),
    );
  }

  void _drawLeftRearWheel(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15 * sx, 160 * sy, 20 * sx, 45 * sy),
        Radius.circular(8 * min(sx, sy)),
      ),
      Paint()..color = _wheel,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15 * sx, 160 * sy, 20 * sx, 45 * sy),
        Radius.circular(8 * min(sx, sy)),
      ),
      Paint()
        ..color = _rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * min(sx, sy),
    );
    canvas.drawLine(
      Offset(25 * sx, 165 * sy), Offset(25 * sx, 200 * sy),
      Paint()..color = _rim.withValues(alpha: 0.5)..strokeWidth = 1 * min(sx, sy),
    );
  }

  void _drawRightRearWheel(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(85 * sx, 160 * sy, 20 * sx, 45 * sy),
        Radius.circular(8 * min(sx, sy)),
      ),
      Paint()..color = _wheel,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(85 * sx, 160 * sy, 20 * sx, 45 * sy),
        Radius.circular(8 * min(sx, sy)),
      ),
      Paint()
        ..color = _rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * min(sx, sy),
    );
    canvas.drawLine(
      Offset(95 * sx, 165 * sy), Offset(95 * sx, 200 * sy),
      Paint()..color = _rim.withValues(alpha: 0.5)..strokeWidth = 1 * min(sx, sy),
    );
  }

  void _drawLeftFrontWheel(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18 * sx, 42 * sy, 18 * sx, 35 * sy),
        Radius.circular(7 * min(sx, sy)),
      ),
      Paint()..color = _wheel,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18 * sx, 42 * sy, 18 * sx, 35 * sy),
        Radius.circular(7 * min(sx, sy)),
      ),
      Paint()
        ..color = _rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * min(sx, sy),
    );
  }

  void _drawRightFrontWheel(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(84 * sx, 42 * sy, 18 * sx, 35 * sy),
        Radius.circular(7 * min(sx, sy)),
      ),
      Paint()..color = _wheel,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(84 * sx, 42 * sy, 18 * sx, 35 * sy),
        Radius.circular(7 * min(sx, sy)),
      ),
      Paint()
        ..color = _rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * min(sx, sy),
    );
  }

  void _drawStripes(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(50 * sx, 50 * sy, 20 * sx, 120 * sy),
        Radius.circular(4 * min(sx, sy)),
      ),
      Paint()..color = _stripe.withValues(alpha: 0.25),
    );
    // Number circle
    canvas.drawCircle(
      Offset(60 * sx, 140 * sy),
      12 * min(sx, sy),
      Paint()..color = _stripe.withValues(alpha: 0.4),
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: '1',
        style: TextStyle(
          fontSize: 14 * min(sx, sy),
          fontWeight: FontWeight.w800,
          color: _body2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(60 * sx - textPainter.width / 2, 140 * sy - textPainter.height / 2),
    );
  }

  void _drawExhaust(Canvas canvas, double sx, double sy) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(48 * sx, 210 * sy), width: 16 * sx, height: 20 * sy),
      Paint()..color = _accent.withValues(alpha: 0.5),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(72 * sx, 210 * sy), width: 16 * sx, height: 20 * sy),
      Paint()..color = _accent.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(CarPainter oldDelegate) =>
      builtParts != oldDelegate.builtParts || colorScheme != oldDelegate.colorScheme;
}
