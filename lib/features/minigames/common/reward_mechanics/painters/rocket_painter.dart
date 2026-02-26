import 'dart:math';
import 'package:flutter/material.dart';

class RocketPainter extends CustomPainter {
  final int builtParts;
  final Map<String, Color> colorScheme;

  RocketPainter({
    required this.builtParts,
    required this.colorScheme,
  });

  Color get _body1 => colorScheme['body1'] ?? const Color(0xFFD0D8E8);
  Color get _body2 => colorScheme['body2'] ?? const Color(0xFF8899BB);
  Color get _nose => colorScheme['nose'] ?? const Color(0xFFE94560);
  Color get _fins => colorScheme['fins'] ?? const Color(0xFFE94560);
  Color get _window => colorScheme['window'] ?? const Color(0xFF00D4FF);
  Color get _trim => colorScheme['trim'] ?? const Color(0xFFFFC947);
  Color get _engine => colorScheme['engine'] ?? const Color(0xFF556677);
  Color get _flame => colorScheme['flame'] ?? const Color(0xFFFFC947);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 120;
    final sy = size.height / 280;

    // Draw ghost outline first
    _drawGhost(canvas, sx, sy);

    // Draw built parts
    if (builtParts >= 1) _drawBody(canvas, sx, sy);
    if (builtParts >= 2) _drawNose(canvas, sx, sy);
    if (builtParts >= 3) _drawMainWindow(canvas, sx, sy);
    if (builtParts >= 4) _drawSmallWindow(canvas, sx, sy);
    if (builtParts >= 5) _drawLeftFin(canvas, sx, sy);
    if (builtParts >= 6) _drawRightFin(canvas, sx, sy);
    if (builtParts >= 7) _drawEngine(canvas, sx, sy);
    if (builtParts >= 8) _drawAntenna(canvas, sx, sy);
    if (builtParts >= 9) _drawMarkings(canvas, sx, sy);
    if (builtParts >= 10) _drawFlame(canvas, sx, sy);
  }

  void _drawGhost(Canvas canvas, double sx, double sy) {
    final ghostPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    // Ghost body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(36 * sx, 50 * sy, 48 * sx, 130 * sy),
        Radius.circular(24 * min(sx, sy)),
      ),
      ghostPaint,
    );
    // Ghost nose
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 52 * sy), width: 28 * sx, height: 56 * sy),
      ghostPaint,
    );
    // Ghost fins
    final leftFinPath = Path()
      ..moveTo(36 * sx, 148 * sy)
      ..lineTo(16 * sx, 198 * sy)
      ..lineTo(40 * sx, 178 * sy)
      ..close();
    canvas.drawPath(leftFinPath, ghostPaint);
    final rightFinPath = Path()
      ..moveTo(84 * sx, 148 * sy)
      ..lineTo(104 * sx, 198 * sy)
      ..lineTo(80 * sx, 178 * sy)
      ..close();
    canvas.drawPath(rightFinPath, ghostPaint);
    // Ghost engine
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(44 * sx, 178 * sy, 32 * sx, 14 * sy),
        Radius.circular(4 * min(sx, sy)),
      ),
      ghostPaint,
    );
    // Ghost window circles
    canvas.drawCircle(Offset(60 * sx, 105 * sy), 16 * min(sx, sy), ghostPaint..color = Colors.white.withValues(alpha: 0.05));
    canvas.drawCircle(Offset(60 * sx, 145 * sy), 10 * min(sx, sy), ghostPaint);
  }

  void _drawBody(Canvas canvas, double sx, double sy) {
    final bodyGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [_body1, _body2],
    );
    final rect = Rect.fromLTWH(36 * sx, 50 * sy, 48 * sx, 130 * sy);
    final bodyPaint = Paint()
      ..shader = bodyGradient.createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(24 * min(sx, sy))),
      bodyPaint,
    );
    // Detail lines
    final linePaint = Paint()
      ..color = _body2.withValues(alpha: 0.4)
      ..strokeWidth = 0.7 * min(sx, sy);
    canvas.drawLine(Offset(42 * sx, 80 * sy), Offset(42 * sx, 170 * sy), linePaint);
    canvas.drawLine(Offset(78 * sx, 80 * sy), Offset(78 * sx, 170 * sy), linePaint);
  }

  void _drawNose(Canvas canvas, double sx, double sy) {
    final nosePaint = Paint()..color = _nose;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 52 * sy), width: 28 * sx, height: 56 * sy),
      nosePaint,
    );
    // Highlight
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 40 * sy), width: 8 * sx, height: 16 * sy),
      Paint()..color = Colors.white.withValues(alpha: 0.15),
    );
  }

  void _drawMainWindow(Canvas canvas, double sx, double sy) {
    // Window frame
    canvas.drawCircle(
      Offset(60 * sx, 105 * sy),
      16 * min(sx, sy),
      Paint()..color = const Color(0xFF0B1528),
    );
    canvas.drawCircle(
      Offset(60 * sx, 105 * sy),
      16 * min(sx, sy),
      Paint()
        ..color = _trim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * min(sx, sy),
    );
    // Window glass
    canvas.drawCircle(
      Offset(60 * sx, 105 * sy),
      10 * min(sx, sy),
      Paint()..color = _window.withValues(alpha: 0.8),
    );
    // Highlight
    canvas.drawOval(
      Rect.fromCenter(center: Offset(55 * sx, 100 * sy), width: 8 * sx, height: 6 * sy),
      Paint()..color = Colors.white.withValues(alpha: 0.25),
    );
  }

  void _drawSmallWindow(Canvas canvas, double sx, double sy) {
    canvas.drawCircle(
      Offset(60 * sx, 145 * sy),
      10 * min(sx, sy),
      Paint()..color = const Color(0xFF0B1528),
    );
    canvas.drawCircle(
      Offset(60 * sx, 145 * sy),
      10 * min(sx, sy),
      Paint()
        ..color = _trim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * min(sx, sy),
    );
    canvas.drawCircle(
      Offset(60 * sx, 145 * sy),
      6 * min(sx, sy),
      Paint()..color = _window.withValues(alpha: 0.6),
    );
  }

  void _drawLeftFin(Canvas canvas, double sx, double sy) {
    final finPath = Path()
      ..moveTo(36 * sx, 148 * sy)
      ..lineTo(16 * sx, 198 * sy)
      ..lineTo(40 * sx, 178 * sy)
      ..close();
    canvas.drawPath(finPath, Paint()..color = _fins.withValues(alpha: 0.9));
    // Highlight
    final hlPath = Path()
      ..moveTo(36 * sx, 155 * sy)
      ..lineTo(24 * sx, 185 * sy)
      ..lineTo(38 * sx, 174 * sy)
      ..close();
    canvas.drawPath(hlPath, Paint()..color = Colors.white.withValues(alpha: 0.1));
  }

  void _drawRightFin(Canvas canvas, double sx, double sy) {
    final finPath = Path()
      ..moveTo(84 * sx, 148 * sy)
      ..lineTo(104 * sx, 198 * sy)
      ..lineTo(80 * sx, 178 * sy)
      ..close();
    canvas.drawPath(finPath, Paint()..color = _fins.withValues(alpha: 0.9));
    final hlPath = Path()
      ..moveTo(84 * sx, 155 * sy)
      ..lineTo(96 * sx, 185 * sy)
      ..lineTo(82 * sx, 174 * sy)
      ..close();
    canvas.drawPath(hlPath, Paint()..color = Colors.white.withValues(alpha: 0.1));
  }

  void _drawEngine(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(44 * sx, 178 * sy, 32 * sx, 14 * sy),
        Radius.circular(4 * min(sx, sy)),
      ),
      Paint()..color = _engine,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(44 * sx, 178 * sy, 32 * sx, 14 * sy),
        Radius.circular(4 * min(sx, sy)),
      ),
      Paint()
        ..color = const Color(0xFF778899)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 * min(sx, sy),
    );
    // Inner detail
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(48 * sx, 181 * sy, 24 * sx, 8 * sy),
        Radius.circular(3 * min(sx, sy)),
      ),
      Paint()..color = const Color(0xFF222222),
    );
  }

  void _drawAntenna(Canvas canvas, double sx, double sy) {
    canvas.drawLine(
      Offset(60 * sx, 26 * sy),
      Offset(60 * sx, 12 * sy),
      Paint()
        ..color = const Color(0xFFCCCCCC)
        ..strokeWidth = 2.5 * min(sx, sy)
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(60 * sx, 10 * sy),
      4 * min(sx, sy),
      Paint()..color = _trim,
    );
  }

  void _drawMarkings(Canvas canvas, double sx, double sy) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(40 * sx, 78 * sy, 40 * sx, 4 * sy),
        Radius.circular(2 * min(sx, sy)),
      ),
      Paint()..color = _trim.withValues(alpha: 0.8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(40 * sx, 162 * sy, 40 * sx, 4 * sy),
        Radius.circular(2 * min(sx, sy)),
      ),
      Paint()..color = _trim.withValues(alpha: 0.8),
    );
    // "MATH" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'MATH',
        style: TextStyle(
          fontSize: 9 * min(sx, sy),
          fontWeight: FontWeight.w800,
          color: _trim.withValues(alpha: 0.7),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(60 * sx - textPainter.width / 2, 85 * sy),
    );
  }

  void _drawFlame(Canvas canvas, double sx, double sy) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 200 * sy), width: 28 * sx, height: 14 * sy),
      Paint()..color = _flame.withValues(alpha: 0.5),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 206 * sy), width: 16 * sx, height: 20 * sy),
      Paint()..color = const Color(0xFFFF6B00).withValues(alpha: 0.4),
    );
  }

  @override
  bool shouldRepaint(RocketPainter oldDelegate) =>
      builtParts != oldDelegate.builtParts || colorScheme != oldDelegate.colorScheme;
}
