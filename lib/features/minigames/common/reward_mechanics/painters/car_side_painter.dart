import 'package:flutter/material.dart';

/// Side-view car painter used for the race/launch animation screen.
/// Matches the horizontal car SVG from the HTML prototype (viewBox 200x100).
class CarSidePainter extends CustomPainter {
  final Map<String, Color> colorScheme;

  CarSidePainter({required this.colorScheme});

  Color get _body => colorScheme['body'] ?? const Color(0xFFE74C3C);
  Color get _body2 => colorScheme['body2'] ?? const Color(0xFFC0392B);
  Color get _window => colorScheme['window'] ?? const Color(0xFF5DADE2);
  Color get _wheel => colorScheme['wheel'] ?? const Color(0xFF333333);
  Color get _rim => colorScheme['rim'] ?? const Color(0xFF888888);
  Color get _stripe => colorScheme['stripe'] ?? const Color(0xFFFFD740);
  Color get _accent => colorScheme['accent'] ?? const Color(0xFFFF6B6B);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 200;
    final sy = size.height / 100;

    // Main body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(40 * sx, 35 * sy, 120 * sx, 40 * sy),
        Radius.circular(12 * sx),
      ),
      Paint()..color = _body,
    );

    // Cockpit / roof
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(60 * sx, 15 * sy, 75 * sx, 30 * sy),
        Radius.circular(10 * sx),
      ),
      Paint()..color = _body2,
    );

    // Left wheel (rear)
    canvas.drawCircle(
      Offset(65 * sx, 78 * sy),
      14 * sx,
      Paint()..color = _wheel,
    );
    canvas.drawCircle(
      Offset(65 * sx, 78 * sy),
      14 * sx,
      Paint()
        ..color = _rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * sx,
    );
    canvas.drawCircle(
      Offset(65 * sx, 78 * sy),
      6 * sx,
      Paint()..color = const Color(0xFF555555),
    );

    // Right wheel (front)
    canvas.drawCircle(
      Offset(140 * sx, 78 * sy),
      14 * sx,
      Paint()..color = _wheel,
    );
    canvas.drawCircle(
      Offset(140 * sx, 78 * sy),
      14 * sx,
      Paint()
        ..color = _rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * sx,
    );
    canvas.drawCircle(
      Offset(140 * sx, 78 * sy),
      6 * sx,
      Paint()..color = const Color(0xFF555555),
    );

    // Left window
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(70 * sx, 22 * sy, 22 * sx, 16 * sy),
        Radius.circular(3 * sx),
      ),
      Paint()..color = _window.withValues(alpha: 0.7),
    );

    // Right window
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(96 * sx, 22 * sy, 22 * sx, 16 * sy),
        Radius.circular(3 * sx),
      ),
      Paint()..color = _window.withValues(alpha: 0.7),
    );

    // Left stripe accent
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(42 * sx, 42 * sy, 8 * sx, 12 * sy),
        Radius.circular(2 * sx),
      ),
      Paint()..color = _stripe,
    );

    // Right accent light
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(150 * sx, 42 * sy, 8 * sx, 12 * sy),
        Radius.circular(2 * sx),
      ),
      Paint()..color = _accent,
    );

    // Underside stripe
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(80 * sx, 52 * sy, 40 * sx, 4 * sy),
        Radius.circular(2 * sx),
      ),
      Paint()..color = _stripe.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(CarSidePainter oldDelegate) =>
      colorScheme != oldDelegate.colorScheme;
}
