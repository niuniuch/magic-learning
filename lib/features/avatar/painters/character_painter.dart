import 'dart:math';
import 'package:flutter/material.dart';

/// Full-body character painter for the 6 avatar personas.
/// ViewBox: 200 x 360. Scale to any widget size.
class CharacterPainter extends CustomPainter {
  final int characterIndex;
  final int level;

  CharacterPainter({
    required this.characterIndex,
    this.level = 0,
  });

  int get tier => level ~/ 5; // 0-4

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 200;
    final sy = size.height / 360;

    switch (characterIndex % 6) {
      case 0:
        _drawMage(canvas, sx, sy);
        _drawMageUpgrades(canvas, sx, sy);
      case 1:
        _drawFairy(canvas, sx, sy);
        _drawFairyUpgrades(canvas, sx, sy);
      case 2:
        _drawMerperson(canvas, sx, sy);
        _drawMerpersonUpgrades(canvas, sx, sy);
      case 3:
        _drawSuperhero(canvas, sx, sy);
        _drawSuperheroUpgrades(canvas, sx, sy);
      case 4:
        _drawAlien(canvas, sx, sy);
        _drawAlienUpgrades(canvas, sx, sy);
      case 5:
        _drawRobot(canvas, sx, sy);
        _drawRobotUpgrades(canvas, sx, sy);
    }
  }

  // ─── MAGE ─────────────────────────────────────────────
  void _drawMage(Canvas canvas, double sx, double sy) {
    final purple = Paint()..color = const Color(0xFF7E57C2);
    final darkPurple = Paint()..color = const Color(0xFF512DA8);
    final skin = Paint()..color = const Color(0xFFFFDBAC);
    final gold = Paint()..color = const Color(0xFFFFD740);
    final white = Paint()..color = Colors.white;
    final beard = Paint()..color = const Color(0xFFECEFF1);

    // Robe body
    final robePath = Path()
      ..moveTo(60 * sx, 160 * sy)
      ..quadraticBezierTo(55 * sx, 200 * sy, 45 * sx, 320 * sy)
      ..lineTo(155 * sx, 320 * sy)
      ..quadraticBezierTo(145 * sx, 200 * sy, 140 * sx, 160 * sy)
      ..close();
    canvas.drawPath(robePath, purple);

    // Robe trim
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(43 * sx, 310 * sy, 114 * sx, 12 * sy),
        Radius.circular(4 * sx),
      ),
      darkPurple,
    );

    // Belt
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(65 * sx, 200 * sy, 70 * sx, 10 * sy),
        Radius.circular(3 * sx),
      ),
      gold,
    );
    // Belt buckle
    canvas.drawCircle(Offset(100 * sx, 205 * sy), 6 * sx, darkPurple);
    canvas.drawCircle(Offset(100 * sx, 205 * sy), 4 * sx, gold);

    // Left sleeve
    final leftSleeve = Path()
      ..moveTo(60 * sx, 165 * sy)
      ..quadraticBezierTo(25 * sx, 190 * sy, 30 * sx, 230 * sy)
      ..lineTo(50 * sx, 225 * sy)
      ..quadraticBezierTo(50 * sx, 195 * sy, 70 * sx, 175 * sy)
      ..close();
    canvas.drawPath(leftSleeve, darkPurple);

    // Right sleeve
    final rightSleeve = Path()
      ..moveTo(140 * sx, 165 * sy)
      ..quadraticBezierTo(175 * sx, 190 * sy, 170 * sx, 230 * sy)
      ..lineTo(150 * sx, 225 * sy)
      ..quadraticBezierTo(150 * sx, 195 * sy, 130 * sx, 175 * sy)
      ..close();
    canvas.drawPath(rightSleeve, darkPurple);

    // Hands
    canvas.drawCircle(Offset(33 * sx, 233 * sy), 8 * sx, skin);
    canvas.drawCircle(Offset(167 * sx, 233 * sy), 8 * sx, skin);

    // Staff (right hand)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(164 * sx, 100 * sy, 5 * sx, 200 * sy),
        Radius.circular(2 * sx),
      ),
      Paint()..color = const Color(0xFF795548),
    );
    // Staff orb
    canvas.drawCircle(
      Offset(166.5 * sx, 98 * sy),
      12 * sx,
      Paint()..color = const Color(0xFF64FFDA).withValues(alpha: 0.7),
    );
    canvas.drawCircle(
      Offset(166.5 * sx, 98 * sy),
      8 * sx,
      Paint()..color = const Color(0xFF64FFDA),
    );
    // Orb glow
    canvas.drawCircle(
      Offset(163 * sx, 94 * sy),
      3 * sx,
      white..color = Colors.white.withValues(alpha: 0.7),
    );

    // Head
    canvas.drawCircle(Offset(100 * sx, 120 * sy), 35 * sx, skin);

    // Eyes
    canvas.drawOval(
      Rect.fromCenter(center: Offset(88 * sx, 118 * sy), width: 10 * sx, height: 12 * sy),
      white..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(112 * sx, 118 * sy), width: 10 * sx, height: 12 * sy),
      white..color = Colors.white,
    );
    canvas.drawCircle(Offset(89 * sx, 119 * sy), 4 * sx, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(113 * sx, 119 * sy), 4 * sx, Paint()..color = const Color(0xFF5D4037));
    // Pupils
    canvas.drawCircle(Offset(90 * sx, 118 * sy), 2 * sx, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(114 * sx, 118 * sy), 2 * sx, Paint()..color = Colors.black);

    // Eyebrows
    final brow = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 2.5 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(82 * sx, 108 * sy), Offset(94 * sx, 106 * sy), brow);
    canvas.drawLine(Offset(106 * sx, 106 * sy), Offset(118 * sx, 108 * sy), brow);

    // Smile
    final smile = Path()
      ..moveTo(90 * sx, 134 * sy)
      ..quadraticBezierTo(100 * sx, 142 * sy, 110 * sx, 134 * sy);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round,
    );

    // Beard
    final beardPath = Path()
      ..moveTo(80 * sx, 140 * sy)
      ..quadraticBezierTo(85 * sx, 155 * sy, 82 * sx, 180 * sy)
      ..quadraticBezierTo(100 * sx, 190 * sy, 118 * sx, 180 * sy)
      ..quadraticBezierTo(115 * sx, 155 * sy, 120 * sx, 140 * sy)
      ..quadraticBezierTo(100 * sx, 150 * sy, 80 * sx, 140 * sy);
    canvas.drawPath(beardPath, beard..color = const Color(0xFFECEFF1));

    // Pointy hat
    final hatPath = Path()
      ..moveTo(60 * sx, 100 * sy)
      ..lineTo(100 * sx, 20 * sy)
      ..lineTo(140 * sx, 100 * sy)
      ..close();
    canvas.drawPath(hatPath, darkPurple);
    // Hat brim
    canvas.drawOval(
      Rect.fromCenter(center: Offset(100 * sx, 100 * sy), width: 100 * sx, height: 18 * sy),
      darkPurple,
    );
    // Hat star
    _drawStar(canvas, 100 * sx, 55 * sy, 10 * sx, gold);
    // Hat band
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(72 * sx, 88 * sy, 56 * sx, 8 * sy),
        Radius.circular(3 * sx),
      ),
      gold,
    );

    // Shoes peeking out
    canvas.drawOval(
      Rect.fromCenter(center: Offset(70 * sx, 328 * sy), width: 30 * sx, height: 14 * sy),
      darkPurple,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(130 * sx, 328 * sy), width: 30 * sx, height: 14 * sy),
      darkPurple,
    );
  }

  // ─── FAIRY ────────────────────────────────────────────
  void _drawFairy(Canvas canvas, double sx, double sy) {
    final pink = Paint()..color = const Color(0xFFFF69B4);
    final darkPink = Paint()..color = const Color(0xFFE91E8C);
    final skin = Paint()..color = const Color(0xFFFFDBAC);
    final lilac = Paint()..color = const Color(0xFFCE93D8);
    final sparkle = Paint()..color = const Color(0xFFFFD700);

    // Wings (behind body)
    final wingAlpha = Paint()..color = const Color(0xFF80DEEA).withValues(alpha: 0.35);
    // Left wing
    final leftWing = Path()
      ..moveTo(75 * sx, 150 * sy)
      ..quadraticBezierTo(10 * sx, 110 * sy, 20 * sx, 170 * sy)
      ..quadraticBezierTo(30 * sx, 210 * sy, 75 * sx, 195 * sy)
      ..close();
    canvas.drawPath(leftWing, wingAlpha);
    canvas.drawPath(
      leftWing,
      Paint()
        ..color = const Color(0xFF80DEEA).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * sx,
    );
    // Right wing
    final rightWing = Path()
      ..moveTo(125 * sx, 150 * sy)
      ..quadraticBezierTo(190 * sx, 110 * sy, 180 * sx, 170 * sy)
      ..quadraticBezierTo(170 * sx, 210 * sy, 125 * sx, 195 * sy)
      ..close();
    canvas.drawPath(rightWing, wingAlpha);
    canvas.drawPath(
      rightWing,
      Paint()
        ..color = const Color(0xFF80DEEA).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * sx,
    );

    // Dress body
    final dressPath = Path()
      ..moveTo(70 * sx, 155 * sy)
      ..quadraticBezierTo(65 * sx, 220 * sy, 40 * sx, 310 * sy)
      ..quadraticBezierTo(100 * sx, 325 * sy, 160 * sx, 310 * sy)
      ..quadraticBezierTo(135 * sx, 220 * sy, 130 * sx, 155 * sy)
      ..close();
    canvas.drawPath(dressPath, pink);

    // Dress layers
    final layer1 = Path()
      ..moveTo(52 * sx, 270 * sy)
      ..quadraticBezierTo(100 * sx, 280 * sy, 148 * sx, 270 * sy)
      ..quadraticBezierTo(100 * sx, 290 * sy, 52 * sx, 270 * sy);
    canvas.drawPath(layer1, darkPink);
    final layer2 = Path()
      ..moveTo(44 * sx, 295 * sy)
      ..quadraticBezierTo(100 * sx, 305 * sy, 156 * sx, 295 * sy)
      ..quadraticBezierTo(100 * sx, 315 * sy, 44 * sx, 295 * sy);
    canvas.drawPath(layer2, darkPink);

    // Arms
    canvas.drawLine(
      Offset(70 * sx, 165 * sy),
      Offset(40 * sx, 220 * sy),
      Paint()
        ..color = const Color(0xFFFFDBAC)
        ..strokeWidth = 8 * sx
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(130 * sx, 165 * sy),
      Offset(160 * sx, 210 * sy),
      Paint()
        ..color = const Color(0xFFFFDBAC)
        ..strokeWidth = 8 * sx
        ..strokeCap = StrokeCap.round,
    );

    // Wand (right hand)
    canvas.drawLine(
      Offset(160 * sx, 210 * sy),
      Offset(175 * sx, 160 * sy),
      Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 3 * sx
        ..strokeCap = StrokeCap.round,
    );
    _drawStar(canvas, 175 * sx, 155 * sy, 8 * sx, sparkle);

    // Hands
    canvas.drawCircle(Offset(40 * sx, 222 * sy), 6 * sx, skin);
    canvas.drawCircle(Offset(160 * sx, 212 * sy), 6 * sx, skin);

    // Head
    canvas.drawCircle(Offset(100 * sx, 115 * sy), 38 * sx, skin);

    // Hair
    final hairColor = Paint()..color = const Color(0xFFFFB74D);
    // Left hair
    final leftHair = Path()
      ..moveTo(65 * sx, 100 * sy)
      ..quadraticBezierTo(55 * sx, 130 * sy, 60 * sx, 165 * sy)
      ..quadraticBezierTo(62 * sx, 140 * sy, 68 * sx, 115 * sy)
      ..close();
    canvas.drawPath(leftHair, hairColor);
    // Right hair
    final rightHair = Path()
      ..moveTo(135 * sx, 100 * sy)
      ..quadraticBezierTo(145 * sx, 130 * sy, 140 * sx, 165 * sy)
      ..quadraticBezierTo(138 * sx, 140 * sy, 132 * sx, 115 * sy)
      ..close();
    canvas.drawPath(rightHair, hairColor);
    // Top hair
    final topHair = Path()
      ..moveTo(65 * sx, 105 * sy)
      ..quadraticBezierTo(80 * sx, 70 * sy, 100 * sx, 72 * sy)
      ..quadraticBezierTo(120 * sx, 70 * sy, 135 * sx, 105 * sy)
      ..quadraticBezierTo(120 * sx, 80 * sy, 100 * sx, 78 * sy)
      ..quadraticBezierTo(80 * sx, 80 * sy, 65 * sx, 105 * sy);
    canvas.drawPath(topHair, hairColor);

    // Flower crown
    for (var i = 0; i < 5; i++) {
      final angle = -pi * 0.15 + (pi * 0.3 / 4) * i;
      final cx = 100 * sx + cos(angle - pi / 2) * 32 * sx;
      final cy = 95 * sy + sin(angle - pi / 2) * 32 * sy;
      canvas.drawCircle(
        Offset(cx, cy),
        5 * sx,
        Paint()..color = i.isEven ? const Color(0xFFFF69B4) : const Color(0xFFCE93D8),
      );
      canvas.drawCircle(Offset(cx, cy), 2 * sx, sparkle);
    }

    // Eyes
    canvas.drawOval(
      Rect.fromCenter(center: Offset(87 * sx, 115 * sy), width: 12 * sx, height: 14 * sy),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(113 * sx, 115 * sy), width: 12 * sx, height: 14 * sy),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(Offset(88 * sx, 116 * sy), 5 * sx, Paint()..color = const Color(0xFF4CAF50));
    canvas.drawCircle(Offset(114 * sx, 116 * sy), 5 * sx, Paint()..color = const Color(0xFF4CAF50));
    canvas.drawCircle(Offset(89 * sx, 115 * sy), 2.5 * sx, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(115 * sx, 115 * sy), 2.5 * sx, Paint()..color = Colors.black);
    // Eye sparkles
    canvas.drawCircle(Offset(86 * sx, 113 * sy), 1.5 * sx, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(112 * sx, 113 * sy), 1.5 * sx, Paint()..color = Colors.white);

    // Blush
    canvas.drawOval(
      Rect.fromCenter(center: Offset(78 * sx, 126 * sy), width: 12 * sx, height: 6 * sy),
      Paint()..color = const Color(0xFFFF69B4).withValues(alpha: 0.3),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(122 * sx, 126 * sy), width: 12 * sx, height: 6 * sy),
      Paint()..color = const Color(0xFFFF69B4).withValues(alpha: 0.3),
    );

    // Smile
    final smile = Path()
      ..moveTo(90 * sx, 130 * sy)
      ..quadraticBezierTo(100 * sx, 138 * sy, 110 * sx, 130 * sy);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFFE91E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round,
    );

    // Shoes
    canvas.drawOval(
      Rect.fromCenter(center: Offset(70 * sx, 322 * sy), width: 24 * sx, height: 12 * sy),
      lilac,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(130 * sx, 322 * sy), width: 24 * sx, height: 12 * sy),
      lilac,
    );
  }

  // ─── MERPERSON ────────────────────────────────────────
  void _drawMerperson(Canvas canvas, double sx, double sy) {
    final teal = Paint()..color = const Color(0xFF00BCD4);
    final darkTeal = Paint()..color = const Color(0xFF00838F);
    final skin = Paint()..color = const Color(0xFFFFDBAC);
    final coral = Paint()..color = const Color(0xFFFF7043);
    final gold = Paint()..color = const Color(0xFFFFD740);

    // Tail
    final tailPath = Path()
      ..moveTo(70 * sx, 220 * sy)
      ..quadraticBezierTo(65 * sx, 270 * sy, 80 * sx, 310 * sy)
      ..quadraticBezierTo(90 * sx, 330 * sy, 100 * sx, 340 * sy)
      ..quadraticBezierTo(110 * sx, 330 * sy, 120 * sx, 310 * sy)
      ..quadraticBezierTo(135 * sx, 270 * sy, 130 * sx, 220 * sy)
      ..close();
    canvas.drawPath(tailPath, teal);

    // Tail scales pattern
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 3; col++) {
        final cx = (85 + col * 15.0) * sx;
        final cy = (235 + row * 18.0) * sy;
        canvas.drawArc(
          Rect.fromCenter(center: Offset(cx, cy), width: 14 * sx, height: 12 * sy),
          0,
          pi,
          false,
          Paint()
            ..color = const Color(0xFF26C6DA).withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2 * sx,
        );
      }
    }

    // Tail fin
    final finLeft = Path()
      ..moveTo(90 * sx, 335 * sy)
      ..quadraticBezierTo(60 * sx, 340 * sy, 55 * sx, 355 * sy)
      ..quadraticBezierTo(75 * sx, 345 * sy, 100 * sx, 342 * sy)
      ..close();
    canvas.drawPath(finLeft, darkTeal);
    final finRight = Path()
      ..moveTo(110 * sx, 335 * sy)
      ..quadraticBezierTo(140 * sx, 340 * sy, 145 * sx, 355 * sy)
      ..quadraticBezierTo(125 * sx, 345 * sy, 100 * sx, 342 * sy)
      ..close();
    canvas.drawPath(finRight, darkTeal);

    // Torso
    final torsoPath = Path()
      ..moveTo(70 * sx, 150 * sy)
      ..quadraticBezierTo(65 * sx, 185 * sy, 70 * sx, 225 * sy)
      ..lineTo(130 * sx, 225 * sy)
      ..quadraticBezierTo(135 * sx, 185 * sy, 130 * sx, 150 * sy)
      ..close();
    canvas.drawPath(torsoPath, skin);

    // Shell top
    canvas.drawArc(
      Rect.fromCenter(center: Offset(85 * sx, 165 * sy), width: 24 * sx, height: 20 * sy),
      pi,
      pi,
      true,
      coral,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(115 * sx, 165 * sy), width: 24 * sx, height: 20 * sy),
      pi,
      pi,
      true,
      coral,
    );

    // Arms
    canvas.drawLine(
      Offset(70 * sx, 160 * sy),
      Offset(35 * sx, 210 * sy),
      Paint()
        ..color = const Color(0xFFFFDBAC)
        ..strokeWidth = 8 * sx
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(130 * sx, 160 * sy),
      Offset(165 * sx, 200 * sy),
      Paint()
        ..color = const Color(0xFFFFDBAC)
        ..strokeWidth = 8 * sx
        ..strokeCap = StrokeCap.round,
    );

    // Trident (right hand)
    canvas.drawLine(
      Offset(165 * sx, 200 * sy),
      Offset(170 * sx, 80 * sy),
      Paint()
        ..color = const Color(0xFFFFD740)
        ..strokeWidth = 3 * sx
        ..strokeCap = StrokeCap.round,
    );
    // Trident prongs
    for (final dx in [-8.0, 0.0, 8.0]) {
      canvas.drawLine(
        Offset((170 + dx) * sx, 95 * sy),
        Offset((170 + dx) * sx, 75 * sy),
        Paint()
          ..color = const Color(0xFFFFD740)
          ..strokeWidth = 2.5 * sx
          ..strokeCap = StrokeCap.round,
      );
    }

    // Hands
    canvas.drawCircle(Offset(35 * sx, 212 * sy), 6 * sx, skin);
    canvas.drawCircle(Offset(165 * sx, 202 * sy), 6 * sx, skin);

    // Head
    canvas.drawCircle(Offset(100 * sx, 110 * sy), 38 * sx, skin);

    // Hair
    final hairColor = Paint()..color = const Color(0xFF1565C0);
    final hairPath = Path()
      ..moveTo(62 * sx, 105 * sy)
      ..quadraticBezierTo(70 * sx, 60 * sy, 100 * sx, 58 * sy)
      ..quadraticBezierTo(130 * sx, 60 * sy, 138 * sx, 105 * sy)
      ..quadraticBezierTo(145 * sx, 140 * sy, 140 * sx, 170 * sy)
      ..quadraticBezierTo(132 * sx, 130 * sy, 130 * sx, 100 * sy)
      ..quadraticBezierTo(115 * sx, 75 * sy, 100 * sx, 72 * sy)
      ..quadraticBezierTo(85 * sx, 75 * sy, 70 * sx, 100 * sy)
      ..quadraticBezierTo(68 * sx, 130 * sy, 60 * sx, 170 * sy)
      ..quadraticBezierTo(55 * sx, 140 * sy, 62 * sx, 105 * sy);
    canvas.drawPath(hairPath, hairColor);

    // Crown
    final crownPath = Path()
      ..moveTo(75 * sx, 75 * sy)
      ..lineTo(78 * sx, 55 * sy)
      ..lineTo(88 * sx, 65 * sy)
      ..lineTo(100 * sx, 45 * sy)
      ..lineTo(112 * sx, 65 * sy)
      ..lineTo(122 * sx, 55 * sy)
      ..lineTo(125 * sx, 75 * sy)
      ..close();
    canvas.drawPath(crownPath, gold);

    // Eyes
    canvas.drawOval(
      Rect.fromCenter(center: Offset(87 * sx, 110 * sy), width: 11 * sx, height: 13 * sy),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(113 * sx, 110 * sy), width: 11 * sx, height: 13 * sy),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(Offset(88 * sx, 111 * sy), 4.5 * sx, Paint()..color = const Color(0xFF00838F));
    canvas.drawCircle(Offset(114 * sx, 111 * sy), 4.5 * sx, Paint()..color = const Color(0xFF00838F));
    canvas.drawCircle(Offset(89 * sx, 110 * sy), 2 * sx, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(115 * sx, 110 * sy), 2 * sx, Paint()..color = Colors.black);

    // Smile
    final smile = Path()
      ..moveTo(90 * sx, 126 * sy)
      ..quadraticBezierTo(100 * sx, 134 * sy, 110 * sx, 126 * sy);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFFE91E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round,
    );
  }

  // ─── SUPERHERO ────────────────────────────────────────
  void _drawSuperhero(Canvas canvas, double sx, double sy) {
    final red = Paint()..color = const Color(0xFFE53935);
    final blue = Paint()..color = const Color(0xFF1E88E5);
    final darkBlue = Paint()..color = const Color(0xFF1565C0);
    final skin = Paint()..color = const Color(0xFFFFDBAC);
    final yellow = Paint()..color = const Color(0xFFFDD835);

    // Cape (behind body)
    final capePath = Path()
      ..moveTo(65 * sx, 150 * sy)
      ..quadraticBezierTo(50 * sx, 220 * sy, 35 * sx, 320 * sy)
      ..quadraticBezierTo(100 * sx, 340 * sy, 165 * sx, 320 * sy)
      ..quadraticBezierTo(150 * sx, 220 * sy, 135 * sx, 150 * sy)
      ..close();
    canvas.drawPath(capePath, red);

    // Boots
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(62 * sx, 295 * sy, 28 * sx, 30 * sy),
        Radius.circular(6 * sx),
      ),
      red,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(110 * sx, 295 * sy, 28 * sx, 30 * sy),
        Radius.circular(6 * sx),
      ),
      red,
    );

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(68 * sx, 240 * sy, 20 * sx, 65 * sy),
        Radius.circular(6 * sx),
      ),
      blue,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(112 * sx, 240 * sy, 20 * sx, 65 * sy),
        Radius.circular(6 * sx),
      ),
      blue,
    );

    // Body suit
    final bodyPath = Path()
      ..moveTo(65 * sx, 150 * sy)
      ..lineTo(60 * sx, 250 * sy)
      ..lineTo(140 * sx, 250 * sy)
      ..lineTo(135 * sx, 150 * sy)
      ..close();
    canvas.drawPath(bodyPath, blue);

    // Belt
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(58 * sx, 235 * sy, 84 * sx, 12 * sy),
        Radius.circular(4 * sx),
      ),
      yellow,
    );
    // Belt buckle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(90 * sx, 233 * sy, 20 * sx, 16 * sy),
        Radius.circular(3 * sx),
      ),
      Paint()..color = const Color(0xFFF9A825),
    );

    // Chest emblem - star
    _drawStar(canvas, 100 * sx, 195 * sy, 16 * sx, yellow);

    // Arms
    canvas.drawLine(
      Offset(65 * sx, 155 * sy),
      Offset(35 * sx, 215 * sy),
      Paint()
        ..color = const Color(0xFF1E88E5)
        ..strokeWidth = 12 * sx
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(135 * sx, 155 * sy),
      Offset(165 * sx, 205 * sy),
      Paint()
        ..color = const Color(0xFF1E88E5)
        ..strokeWidth = 12 * sx
        ..strokeCap = StrokeCap.round,
    );

    // Gloves
    canvas.drawCircle(Offset(33 * sx, 218 * sy), 8 * sx, red);
    canvas.drawCircle(Offset(167 * sx, 208 * sy), 8 * sx, red);

    // Head
    canvas.drawCircle(Offset(100 * sx, 110 * sy), 36 * sx, skin);

    // Hair
    final hairPath = Path()
      ..moveTo(65 * sx, 100 * sy)
      ..quadraticBezierTo(75 * sx, 65 * sy, 100 * sx, 62 * sy)
      ..quadraticBezierTo(125 * sx, 65 * sy, 135 * sx, 100 * sy)
      ..quadraticBezierTo(120 * sx, 80 * sy, 100 * sx, 77 * sy)
      ..quadraticBezierTo(80 * sx, 80 * sy, 65 * sx, 100 * sy);
    canvas.drawPath(hairPath, Paint()..color = const Color(0xFF3E2723));

    // Mask
    final maskPath = Path()
      ..moveTo(68 * sx, 108 * sy)
      ..lineTo(78 * sx, 100 * sy)
      ..lineTo(100 * sx, 105 * sy)
      ..lineTo(122 * sx, 100 * sy)
      ..lineTo(132 * sx, 108 * sy)
      ..lineTo(128 * sx, 118 * sy)
      ..quadraticBezierTo(115 * sx, 112 * sy, 100 * sx, 115 * sy)
      ..quadraticBezierTo(85 * sx, 112 * sy, 72 * sx, 118 * sy)
      ..close();
    canvas.drawPath(maskPath, darkBlue);

    // Eyes through mask
    canvas.drawOval(
      Rect.fromCenter(center: Offset(87 * sx, 110 * sy), width: 10 * sx, height: 8 * sy),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(113 * sx, 110 * sy), width: 10 * sx, height: 8 * sy),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(Offset(88 * sx, 110 * sy), 3 * sx, Paint()..color = const Color(0xFF1565C0));
    canvas.drawCircle(Offset(114 * sx, 110 * sy), 3 * sx, Paint()..color = const Color(0xFF1565C0));

    // Confident smile
    final smile = Path()
      ..moveTo(88 * sx, 128 * sy)
      ..quadraticBezierTo(100 * sx, 138 * sy, 112 * sx, 128 * sy);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * sx
        ..strokeCap = StrokeCap.round,
    );
  }

  // ─── ALIEN ────────────────────────────────────────────
  void _drawAlien(Canvas canvas, double sx, double sy) {
    final green = Paint()..color = const Color(0xFF66BB6A);
    final glow = Paint()..color = const Color(0xFF76FF03);

    // Body / space suit
    final suitPath = Path()
      ..moveTo(65 * sx, 175 * sy)
      ..quadraticBezierTo(55 * sx, 220 * sy, 55 * sx, 280 * sy)
      ..lineTo(145 * sx, 280 * sy)
      ..quadraticBezierTo(145 * sx, 220 * sy, 135 * sx, 175 * sy)
      ..close();
    canvas.drawPath(suitPath, Paint()..color = const Color(0xFF78909C));

    // Suit collar
    canvas.drawArc(
      Rect.fromCenter(center: Offset(100 * sx, 175 * sy), width: 70 * sx, height: 20 * sy),
      0,
      pi,
      false,
      Paint()
        ..color = const Color(0xFF546E7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * sx,
    );

    // Suit belt with tech
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(60 * sx, 230 * sy, 80 * sx, 10 * sy),
        Radius.circular(3 * sx),
      ),
      Paint()..color = const Color(0xFF455A64),
    );
    // Belt lights
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset((80 + i * 20.0) * sx, 235 * sy),
        3 * sx,
        Paint()..color = [const Color(0xFFFF5252), const Color(0xFF69F0AE), const Color(0xFF448AFF)][i],
      );
    }

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(65 * sx, 275 * sy, 22 * sx, 50 * sy),
        Radius.circular(8 * sx),
      ),
      Paint()..color = const Color(0xFF78909C),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(113 * sx, 275 * sy, 22 * sx, 50 * sy),
        Radius.circular(8 * sx),
      ),
      Paint()..color = const Color(0xFF78909C),
    );

    // Boots
    canvas.drawOval(
      Rect.fromCenter(center: Offset(76 * sx, 328 * sy), width: 30 * sx, height: 16 * sy),
      Paint()..color = const Color(0xFF455A64),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(124 * sx, 328 * sy), width: 30 * sx, height: 16 * sy),
      Paint()..color = const Color(0xFF455A64),
    );

    // Arms
    canvas.drawLine(
      Offset(65 * sx, 185 * sy),
      Offset(35 * sx, 240 * sy),
      Paint()
        ..color = const Color(0xFF78909C)
        ..strokeWidth = 10 * sx
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(135 * sx, 185 * sy),
      Offset(165 * sx, 240 * sy),
      Paint()
        ..color = const Color(0xFF78909C)
        ..strokeWidth = 10 * sx
        ..strokeCap = StrokeCap.round,
    );

    // Alien hands (3 fingers)
    for (final dx in [-5.0, 0.0, 5.0]) {
      canvas.drawCircle(Offset((35 + dx) * sx, 245 * sy), 4 * sx, green);
    }
    for (final dx in [-5.0, 0.0, 5.0]) {
      canvas.drawCircle(Offset((165 + dx) * sx, 245 * sy), 4 * sx, green);
    }

    // Head (large oval)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(100 * sx, 105 * sy), width: 90 * sx, height: 100 * sy),
      green,
    );

    // Antenna
    canvas.drawLine(
      Offset(100 * sx, 55 * sy),
      Offset(100 * sx, 30 * sy),
      Paint()
        ..color = const Color(0xFF388E3C)
        ..strokeWidth = 3 * sx
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(100 * sx, 26 * sy), 6 * sx, glow);
    canvas.drawCircle(
      Offset(100 * sx, 26 * sy),
      9 * sx,
      Paint()..color = const Color(0xFF76FF03).withValues(alpha: 0.3),
    );

    // Eyes (huge)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(80 * sx, 100 * sy), width: 32 * sx, height: 38 * sy),
      Paint()..color = Colors.black,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(120 * sx, 100 * sy), width: 32 * sx, height: 38 * sy),
      Paint()..color = Colors.black,
    );
    // Eye highlight
    canvas.drawOval(
      Rect.fromCenter(center: Offset(80 * sx, 100 * sy), width: 26 * sx, height: 30 * sy),
      Paint()..color = const Color(0xFF1B5E20),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(120 * sx, 100 * sy), width: 26 * sx, height: 30 * sy),
      Paint()..color = const Color(0xFF1B5E20),
    );
    // Pupils
    canvas.drawCircle(Offset(82 * sx, 98 * sy), 6 * sx, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(122 * sx, 98 * sy), 6 * sx, Paint()..color = Colors.black);
    // Eye shine
    canvas.drawCircle(Offset(77 * sx, 92 * sy), 4 * sx, Paint()..color = Colors.white.withValues(alpha: 0.7));
    canvas.drawCircle(Offset(117 * sx, 92 * sy), 4 * sx, Paint()..color = Colors.white.withValues(alpha: 0.7));

    // Small smile
    final smile = Path()
      ..moveTo(90 * sx, 125 * sy)
      ..quadraticBezierTo(100 * sx, 132 * sy, 110 * sx, 125 * sy);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF2E7D32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round,
    );
  }

  // ─── ROBOT ────────────────────────────────────────────
  void _drawRobot(Canvas canvas, double sx, double sy) {
    final silver = Paint()..color = const Color(0xFFB0BEC5);
    final darkGray = Paint()..color = const Color(0xFF546E7A);
    final screenGreen = Paint()..color = const Color(0xFF76FF03);
    final accent = Paint()..color = const Color(0xFF00BCD4);

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(65 * sx, 260 * sy, 24 * sx, 55 * sy),
        Radius.circular(4 * sx),
      ),
      darkGray,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(111 * sx, 260 * sy, 24 * sx, 55 * sy),
        Radius.circular(4 * sx),
      ),
      darkGray,
    );
    // Knee joints
    canvas.drawCircle(Offset(77 * sx, 285 * sy), 6 * sx, accent);
    canvas.drawCircle(Offset(123 * sx, 285 * sy), 6 * sx, accent);

    // Feet
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(55 * sx, 310 * sy, 40 * sx, 18 * sy),
        Radius.circular(6 * sx),
      ),
      silver,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(105 * sx, 310 * sy, 40 * sx, 18 * sy),
        Radius.circular(6 * sx),
      ),
      silver,
    );

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(55 * sx, 155 * sy, 90 * sx, 110 * sy),
        Radius.circular(12 * sx),
      ),
      silver,
    );
    // Body panel
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(65 * sx, 170 * sy, 70 * sx, 60 * sy),
        Radius.circular(8 * sx),
      ),
      darkGray,
    );
    // Chest screen
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(72 * sx, 178 * sy, 56 * sx, 35 * sy),
        Radius.circular(4 * sx),
      ),
      Paint()..color = const Color(0xFF263238),
    );
    // Heart icon on screen
    final heartPath = Path()
      ..moveTo(100 * sx, 202 * sy)
      ..cubicTo(100 * sx, 195 * sy, 88 * sx, 185 * sy, 85 * sx, 192 * sy)
      ..cubicTo(82 * sx, 198 * sy, 100 * sx, 207 * sy, 100 * sx, 207 * sy)
      ..cubicTo(100 * sx, 207 * sy, 118 * sx, 198 * sy, 115 * sx, 192 * sy)
      ..cubicTo(112 * sx, 185 * sy, 100 * sx, 195 * sy, 100 * sx, 202 * sy);
    canvas.drawPath(heartPath, screenGreen);

    // Body buttons
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset((80 + i * 20.0) * sx, 245 * sy),
        5 * sx,
        Paint()..color = [const Color(0xFFFF5252), const Color(0xFFFFC107), const Color(0xFF4CAF50)][i],
      );
    }

    // Arms
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30 * sx, 165 * sy, 22 * sx, 60 * sy),
        Radius.circular(6 * sx),
      ),
      darkGray,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(148 * sx, 165 * sy, 22 * sx, 60 * sy),
        Radius.circular(6 * sx),
      ),
      darkGray,
    );
    // Shoulder joints
    canvas.drawCircle(Offset(52 * sx, 168 * sy), 7 * sx, accent);
    canvas.drawCircle(Offset(148 * sx, 168 * sy), 7 * sx, accent);
    // Elbow joints
    canvas.drawCircle(Offset(41 * sx, 228 * sy), 6 * sx, accent);
    canvas.drawCircle(Offset(159 * sx, 228 * sy), 6 * sx, accent);

    // Clamp hands
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30 * sx, 228 * sy, 10 * sx, 20 * sy),
        Radius.circular(3 * sx),
      ),
      silver,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(44 * sx, 228 * sy, 10 * sx, 20 * sy),
        Radius.circular(3 * sx),
      ),
      silver,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(148 * sx, 228 * sy, 10 * sx, 20 * sy),
        Radius.circular(3 * sx),
      ),
      silver,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(162 * sx, 228 * sy, 10 * sx, 20 * sy),
        Radius.circular(3 * sx),
      ),
      silver,
    );

    // Neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(90 * sx, 140 * sy, 20 * sx, 20 * sy),
        Radius.circular(4 * sx),
      ),
      darkGray,
    );

    // Head
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(60 * sx, 55 * sy, 80 * sx, 90 * sy),
        Radius.circular(16 * sx),
      ),
      silver,
    );
    // Face screen
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(68 * sx, 65 * sy, 64 * sx, 55 * sy),
        Radius.circular(10 * sx),
      ),
      Paint()..color = const Color(0xFF263238),
    );

    // Robot eyes on screen
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(78 * sx, 78 * sy, 14 * sx, 14 * sy),
        Radius.circular(3 * sx),
      ),
      accent,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(108 * sx, 78 * sy, 14 * sx, 14 * sy),
        Radius.circular(3 * sx),
      ),
      accent,
    );

    // Robot smile on screen
    final smile = Path()
      ..moveTo(85 * sx, 105 * sy)
      ..lineTo(90 * sx, 110 * sy)
      ..lineTo(110 * sx, 110 * sy)
      ..lineTo(115 * sx, 105 * sy);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF76FF03)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Antenna
    canvas.drawLine(
      Offset(100 * sx, 55 * sy),
      Offset(100 * sx, 35 * sy),
      Paint()
        ..color = const Color(0xFF546E7A)
        ..strokeWidth = 3 * sx
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(100 * sx, 30 * sy), 6 * sx, Paint()..color = const Color(0xFFFF5252));

    // Ear bolts
    canvas.drawCircle(Offset(58 * sx, 95 * sy), 6 * sx, darkGray);
    canvas.drawCircle(Offset(58 * sx, 95 * sy), 3 * sx, accent);
    canvas.drawCircle(Offset(142 * sx, 95 * sy), 6 * sx, darkGray);
    canvas.drawCircle(Offset(142 * sx, 95 * sy), 3 * sx, accent);
  }

  // ─── TIER UPGRADES ─────────────────────────────────────

  // ── Mage upgrades ──
  void _drawMageUpgrades(Canvas canvas, double sx, double sy) {
    if (tier < 1) return;

    // T1: Sparkles around staff orb
    if (tier >= 1) {
      final sparkle = Paint()..color = const Color(0xFF64FFDA).withValues(alpha: 0.6);
      for (final offset in [
        Offset(158 * sx, 88 * sy),
        Offset(176 * sx, 90 * sy),
        Offset(165 * sx, 80 * sy),
      ]) {
        _drawStar(canvas, offset.dx, offset.dy, 4 * sx, sparkle);
      }
    }

    // T2: Star patterns on robe
    if (tier >= 2) {
      final robeStar = Paint()..color = const Color(0xFFFFD740).withValues(alpha: 0.4);
      for (final pos in [
        Offset(80 * sx, 230 * sy),
        Offset(120 * sx, 250 * sy),
        Offset(90 * sx, 275 * sy),
        Offset(110 * sx, 290 * sy),
      ]) {
        _drawStar(canvas, pos.dx, pos.dy, 5 * sx, robeStar);
      }
      // Enhanced hat band - gold glow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(72 * sx, 87 * sy, 56 * sx, 10 * sy),
          Radius.circular(4 * sx),
        ),
        Paint()..color = const Color(0xFFFFD740).withValues(alpha: 0.3),
      );
    }

    // T3: Floating rune circles
    if (tier >= 3) {
      final runePaint = Paint()
        ..color = const Color(0xFF64FFDA).withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * sx;
      for (final pos in [
        Offset(35 * sx, 180 * sy),
        Offset(165 * sx, 280 * sy),
        Offset(25 * sx, 270 * sy),
      ]) {
        canvas.drawCircle(pos, 8 * sx, runePaint);
        _drawStar(canvas, pos.dx, pos.dy, 4 * sx,
            Paint()..color = const Color(0xFF64FFDA).withValues(alpha: 0.5));
      }
    }

    // T4: Gold-trimmed robe edges + massive orb glow
    if (tier >= 4) {
      // Gold trim on robe bottom
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(43 * sx, 308 * sy, 114 * sx, 14 * sy),
          Radius.circular(4 * sx),
        ),
        Paint()..color = const Color(0xFFFFD740).withValues(alpha: 0.6),
      );
      // Massive orb glow
      canvas.drawCircle(
        Offset(166.5 * sx, 98 * sy),
        18 * sx,
        Paint()..color = const Color(0xFF64FFDA).withValues(alpha: 0.2),
      );
      canvas.drawCircle(
        Offset(166.5 * sx, 98 * sy),
        24 * sx,
        Paint()..color = const Color(0xFF64FFDA).withValues(alpha: 0.1),
      );
      // Crown on hat tip
      _drawStar(canvas, 100 * sx, 24 * sy, 8 * sx,
          Paint()..color = const Color(0xFFFFD740));
    }
  }

  // ── Fairy upgrades ──
  void _drawFairyUpgrades(Canvas canvas, double sx, double sy) {
    if (tier < 1) return;

    // T1: Shimmer dots on wings
    if (tier >= 1) {
      final shimmer = Paint()..color = Colors.white.withValues(alpha: 0.5);
      for (final pos in [
        Offset(30 * sx, 140 * sy), Offset(45 * sx, 165 * sy),
        Offset(25 * sx, 180 * sy), Offset(170 * sx, 140 * sy),
        Offset(155 * sx, 165 * sy), Offset(175 * sx, 180 * sy),
      ]) {
        canvas.drawCircle(pos, 2.5 * sx, shimmer);
      }
    }

    // T2: Wand aura + sparkle trail
    if (tier >= 2) {
      // Wand glow rings
      for (var r = 12.0; r <= 20; r += 4) {
        canvas.drawCircle(
          Offset(175 * sx, 155 * sy),
          r * sx,
          Paint()
            ..color = const Color(0xFFFFD700).withValues(alpha: 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5 * sx,
        );
      }
      // Extra sparkle stars
      for (final pos in [
        Offset(168 * sx, 145 * sy),
        Offset(182 * sx, 162 * sy),
      ]) {
        _drawStar(canvas, pos.dx, pos.dy, 4 * sx,
            Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.7));
      }
    }

    // T3: Glowing wings
    if (tier >= 3) {
      final wingGlow = Paint()
        ..color = const Color(0xFF80DEEA).withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      // Left wing glow
      canvas.drawOval(
        Rect.fromCenter(center: Offset(45 * sx, 160 * sy), width: 50 * sx, height: 70 * sy),
        wingGlow,
      );
      // Right wing glow
      canvas.drawOval(
        Rect.fromCenter(center: Offset(155 * sx, 160 * sy), width: 50 * sx, height: 70 * sy),
        wingGlow,
      );
      // Floating petals
      final petal = Paint()..color = const Color(0xFFFF69B4).withValues(alpha: 0.4);
      for (final pos in [
        Offset(55 * sx, 310 * sy), Offset(140 * sx, 325 * sy),
        Offset(45 * sx, 340 * sy),
      ]) {
        canvas.drawOval(
          Rect.fromCenter(center: pos, width: 8 * sx, height: 5 * sy),
          petal,
        );
      }
    }

    // T4: Rainbow gradient wings + golden wand
    if (tier >= 4) {
      // Rainbow shimmer on wings
      final rainbowPaint = Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0x40FF69B4), Color(0x40FFEB3B),
            Color(0x4069F0AE), Color(0x4080DEEA),
            Color(0x40CE93D8),
          ],
        ).createShader(Rect.fromLTWH(10 * sx, 110 * sy, 180 * sx, 100 * sy));
      // Left wing rainbow
      final leftWing = Path()
        ..moveTo(75 * sx, 150 * sy)
        ..quadraticBezierTo(10 * sx, 110 * sy, 20 * sx, 170 * sy)
        ..quadraticBezierTo(30 * sx, 210 * sy, 75 * sx, 195 * sy)
        ..close();
      canvas.drawPath(leftWing, rainbowPaint);
      final rightWing = Path()
        ..moveTo(125 * sx, 150 * sy)
        ..quadraticBezierTo(190 * sx, 110 * sy, 180 * sx, 170 * sy)
        ..quadraticBezierTo(170 * sx, 210 * sy, 125 * sx, 195 * sy)
        ..close();
      canvas.drawPath(rightWing, rainbowPaint);
      // Butterfly companions
      for (final pos in [Offset(30 * sx, 120 * sy), Offset(172 * sx, 130 * sy)]) {
        _drawButterfly(canvas, pos.dx, pos.dy, 6 * sx);
      }
    }
  }

  // ── Merperson upgrades ──
  void _drawMerpersonUpgrades(Canvas canvas, double sx, double sy) {
    if (tier < 1) return;

    // T1: Bubbles rising from tail
    if (tier >= 1) {
      final bubble = Paint()
        ..color = const Color(0xFF80DEEA).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * sx;
      final bubbleFill = Paint()..color = const Color(0xFF80DEEA).withValues(alpha: 0.15);
      for (final data in [
        [40.0, 300.0, 5.0], [155.0, 280.0, 4.0], [35.0, 260.0, 3.0],
        [160.0, 250.0, 3.5], [50.0, 240.0, 2.5],
      ]) {
        final pos = Offset(data[0] * sx, data[1] * sy);
        canvas.drawCircle(pos, data[2] * sx, bubbleFill);
        canvas.drawCircle(pos, data[2] * sx, bubble);
      }
    }

    // T2: Shimmering scales + glowing trident tips
    if (tier >= 2) {
      final shimmer = Paint()..color = const Color(0xFF4DD0E1).withValues(alpha: 0.35);
      for (var row = 0; row < 5; row++) {
        for (var col = 0; col < 3; col++) {
          final cx = (82 + col * 15.0 + (row.isOdd ? 7.0 : 0)) * sx;
          final cy = (238 + row * 18.0) * sy;
          canvas.drawCircle(Offset(cx, cy), 2 * sx, shimmer);
        }
      }
      // Trident glow
      for (final dx in [-8.0, 0.0, 8.0]) {
        canvas.drawCircle(
          Offset((170 + dx) * sx, 74 * sy),
          4 * sx,
          Paint()..color = const Color(0xFFFFD740).withValues(alpha: 0.4),
        );
      }
    }

    // T3: Pearls on crown + water current
    if (tier >= 3) {
      // Pearls
      final pearl = Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.8);
      for (final pos in [
        Offset(88 * sx, 63 * sy), Offset(100 * sx, 50 * sy), Offset(112 * sx, 63 * sy),
      ]) {
        canvas.drawCircle(pos, 3 * sx, pearl);
        canvas.drawCircle(pos, 1.5 * sx,
            Paint()..color = Colors.white.withValues(alpha: 0.5));
      }
      // Water current lines
      final current = Paint()
        ..color = const Color(0xFF26C6DA).withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round;
      for (final y in [270.0, 290.0, 310.0]) {
        final path = Path()
          ..moveTo(40 * sx, y * sy)
          ..quadraticBezierTo(60 * sx, (y - 8) * sy, 80 * sx, y * sy)
          ..quadraticBezierTo(100 * sx, (y + 8) * sy, 120 * sx, y * sy);
        canvas.drawPath(path, current);
      }
    }

    // T4: Royal golden trident + elaborate tail fin
    if (tier >= 4) {
      // Golden glow around entire trident
      canvas.drawLine(
        Offset(170 * sx, 80 * sy), Offset(170 * sx, 200 * sy),
        Paint()
          ..color = const Color(0xFFFFD740).withValues(alpha: 0.15)
          ..strokeWidth = 12 * sx
          ..strokeCap = StrokeCap.round,
      );
      // Crown gem
      canvas.drawCircle(Offset(100 * sx, 48 * sy), 5 * sx,
          Paint()..color = const Color(0xFFFF5252));
      canvas.drawCircle(Offset(100 * sx, 48 * sy), 2.5 * sx,
          Paint()..color = Colors.white.withValues(alpha: 0.6));
      // Tail shimmer
      canvas.drawOval(
        Rect.fromCenter(center: Offset(100 * sx, 300 * sy), width: 70 * sx, height: 50 * sy),
        Paint()..color = const Color(0xFF4DD0E1).withValues(alpha: 0.15),
      );
    }
  }

  // ── Superhero upgrades ──
  void _drawSuperheroUpgrades(Canvas canvas, double sx, double sy) {
    if (tier < 1) return;

    // T1: Glowing star emblem
    if (tier >= 1) {
      for (var r = 20.0; r <= 28; r += 4) {
        canvas.drawCircle(
          Offset(100 * sx, 195 * sy), r * sx,
          Paint()
            ..color = const Color(0xFFFDD835).withValues(alpha: 0.12)
            ..style = PaintingStyle.fill,
        );
      }
    }

    // T2: Power lines from hands
    if (tier >= 2) {
      final bolt = Paint()
        ..color = const Color(0xFFFDD835).withValues(alpha: 0.5)
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round;
      // Left hand bolts
      canvas.drawLine(Offset(28 * sx, 215 * sy), Offset(15 * sx, 200 * sy), bolt);
      canvas.drawLine(Offset(30 * sx, 220 * sy), Offset(12 * sx, 218 * sy), bolt);
      // Right hand bolts
      canvas.drawLine(Offset(172 * sx, 205 * sy), Offset(185 * sx, 190 * sy), bolt);
      canvas.drawLine(Offset(170 * sx, 210 * sy), Offset(188 * sx, 208 * sy), bolt);
    }

    // T3: Cape shimmer lines + power aura
    if (tier >= 3) {
      final shimmer = Paint()
        ..color = const Color(0xFFFF8A80).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * sx;
      for (final y in [200.0, 240.0, 280.0]) {
        final path = Path()
          ..moveTo(50 * sx, y * sy)
          ..quadraticBezierTo(100 * sx, (y - 10) * sy, 150 * sx, y * sy);
        canvas.drawPath(path, shimmer);
      }
      // Body aura
      canvas.drawOval(
        Rect.fromCenter(center: Offset(100 * sx, 200 * sy), width: 100 * sx, height: 130 * sy),
        Paint()
          ..color = const Color(0xFF42A5F5).withValues(alpha: 0.1)
          ..style = PaintingStyle.fill,
      );
    }

    // T4: Speed lines + golden suit accents
    if (tier >= 4) {
      final speed = Paint()
        ..color = const Color(0xFF42A5F5).withValues(alpha: 0.4)
        ..strokeWidth = 2 * sx
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < 6; i++) {
        final y = (140 + i * 30.0) * sy;
        canvas.drawLine(Offset(5 * sx, y), Offset(25 * sx, y), speed);
        canvas.drawLine(Offset(175 * sx, y), Offset(195 * sx, y), speed);
      }
      // Gold belt upgrade
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(58 * sx, 234 * sy, 84 * sx, 14 * sy),
          Radius.circular(4 * sx),
        ),
        Paint()..color = const Color(0xFFFFD740).withValues(alpha: 0.5),
      );
      // Star emblem enhanced
      _drawStar(canvas, 100 * sx, 195 * sy, 20 * sx,
          Paint()..color = const Color(0xFFFDD835).withValues(alpha: 0.4));
    }
  }

  // ── Alien upgrades ──
  void _drawAlienUpgrades(Canvas canvas, double sx, double sy) {
    if (tier < 1) return;

    // T1: Antenna glow rings
    if (tier >= 1) {
      for (var r = 10.0; r <= 18; r += 4) {
        canvas.drawCircle(
          Offset(100 * sx, 26 * sy), r * sx,
          Paint()
            ..color = const Color(0xFF76FF03).withValues(alpha: 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5 * sx,
        );
      }
    }

    // T2: Tech visor + suit stripes
    if (tier >= 2) {
      // Visor overlay on eyes
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(60 * sx, 88 * sy, 80 * sx, 22 * sy),
          Radius.circular(10 * sx),
        ),
        Paint()..color = const Color(0xFF76FF03).withValues(alpha: 0.12),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(60 * sx, 88 * sy, 80 * sx, 22 * sy),
          Radius.circular(10 * sx),
        ),
        Paint()
          ..color = const Color(0xFF76FF03).withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2 * sx,
      );
      // Suit accent stripes
      canvas.drawLine(
        Offset(80 * sx, 180 * sy), Offset(80 * sx, 225 * sy),
        Paint()
          ..color = const Color(0xFF76FF03).withValues(alpha: 0.25)
          ..strokeWidth = 2 * sx,
      );
      canvas.drawLine(
        Offset(120 * sx, 180 * sy), Offset(120 * sx, 225 * sy),
        Paint()
          ..color = const Color(0xFF76FF03).withValues(alpha: 0.25)
          ..strokeWidth = 2 * sx,
      );
    }

    // T3: Energy shield
    if (tier >= 3) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(100 * sx, 180 * sy), width: 120 * sx, height: 200 * sy),
        Paint()
          ..color = const Color(0xFF76FF03).withValues(alpha: 0.08)
          ..style = PaintingStyle.fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(100 * sx, 180 * sy), width: 120 * sx, height: 200 * sy),
        Paint()
          ..color = const Color(0xFF76FF03).withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 * sx,
      );
    }

    // T4: Holographic antenna + chrome suit accents
    if (tier >= 4) {
      // Holographic rings from antenna
      for (var r = 8.0; r <= 30; r += 6) {
        canvas.drawCircle(
          Offset(100 * sx, 26 * sy), r * sx,
          Paint()
            ..color = Color.lerp(const Color(0xFF76FF03), const Color(0xFF00BCD4), r / 30)!
                .withValues(alpha: 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1 * sx,
        );
      }
      // Chrome suit highlights
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(70 * sx, 185 * sy, 60 * sx, 40 * sy),
          Radius.circular(6 * sx),
        ),
        Paint()..color = const Color(0xFFB0BEC5).withValues(alpha: 0.2),
      );
      // Extra belt tech lights
      for (var i = 0; i < 5; i++) {
        canvas.drawCircle(
          Offset((72 + i * 14.0) * sx, 235 * sy), 2 * sx,
          Paint()..color = const Color(0xFF76FF03).withValues(alpha: 0.6),
        );
      }
    }
  }

  // ── Robot upgrades ──
  void _drawRobotUpgrades(Canvas canvas, double sx, double sy) {
    if (tier < 1) return;

    // T1: LED lights on neck
    if (tier >= 1) {
      for (var i = 0; i < 4; i++) {
        canvas.drawCircle(
          Offset((92 + i * 6.0) * sx, 150 * sy), 2 * sx,
          Paint()..color = [
            const Color(0xFFFF5252), const Color(0xFF69F0AE),
            const Color(0xFF448AFF), const Color(0xFFFFEB3B),
          ][i],
        );
      }
    }

    // T2: Enhanced face screen glow + shoulder plates
    if (tier >= 2) {
      // Screen glow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(64 * sx, 61 * sy, 72 * sx, 63 * sy),
          Radius.circular(12 * sx),
        ),
        Paint()
          ..color = const Color(0xFF00BCD4).withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * sx,
      );
      // Shoulder plates
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(44 * sx, 158 * sy, 14 * sx, 18 * sy),
          Radius.circular(3 * sx),
        ),
        Paint()..color = const Color(0xFF00BCD4).withValues(alpha: 0.4),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(142 * sx, 158 * sy, 14 * sx, 18 * sy),
          Radius.circular(3 * sx),
        ),
        Paint()..color = const Color(0xFF00BCD4).withValues(alpha: 0.4),
      );
    }

    // T3: Electric sparks between joints
    if (tier >= 3) {
      final spark = Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: 0.5)
        ..strokeWidth = 1.5 * sx
        ..strokeCap = StrokeCap.round;
      // Shoulder sparks
      _drawZigzag(canvas, 52 * sx, 175 * sy, 38 * sx, 180 * sy, 3, spark);
      _drawZigzag(canvas, 148 * sx, 175 * sy, 160 * sx, 180 * sy, 3, spark);
      // Knee sparks
      _drawZigzag(canvas, 77 * sx, 278 * sy, 77 * sx, 292 * sy, 2, spark);
      _drawZigzag(canvas, 123 * sx, 278 * sy, 123 * sx, 292 * sy, 2, spark);
    }

    // T4: Gold plating + holographic chest display
    if (tier >= 4) {
      // Gold accent lines on body
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(55 * sx, 155 * sy, 90 * sx, 110 * sy),
          Radius.circular(12 * sx),
        ),
        Paint()
          ..color = const Color(0xFFFFD740).withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * sx,
      );
      // Gold head frame
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(60 * sx, 55 * sy, 80 * sx, 90 * sy),
          Radius.circular(16 * sx),
        ),
        Paint()
          ..color = const Color(0xFFFFD740).withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * sx,
      );
      // Antenna upgraded to gold
      canvas.drawCircle(Offset(100 * sx, 30 * sy), 7 * sx,
          Paint()..color = const Color(0xFFFFD740));
    }
  }

  // ─── HELPERS ──────────────────────────────────────────
  void _drawStar(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final outerAngle = -pi / 2 + (2 * pi / 5) * i;
      final innerAngle = outerAngle + pi / 5;
      final ox = cx + cos(outerAngle) * r;
      final oy = cy + sin(outerAngle) * r;
      final ix = cx + cos(innerAngle) * r * 0.4;
      final iy = cy + sin(innerAngle) * r * 0.4;
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawButterfly(Canvas canvas, double cx, double cy, double r) {
    final wing = Paint()..color = const Color(0xFFCE93D8).withValues(alpha: 0.6);
    // Left wing
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - r * 0.6, cy), width: r * 1.2, height: r * 0.8),
      wing,
    );
    // Right wing
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + r * 0.6, cy), width: r * 1.2, height: r * 0.8),
      wing,
    );
    // Body
    canvas.drawLine(
      Offset(cx, cy - r * 0.4), Offset(cx, cy + r * 0.4),
      Paint()
        ..color = const Color(0xFF7B1FA2)
        ..strokeWidth = r * 0.15
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawZigzag(Canvas canvas, double x1, double y1, double x2, double y2, int segments, Paint paint) {
    final dx = (x2 - x1) / segments;
    final dy = (y2 - y1) / segments;
    final perpX = -dy * 0.4;
    final perpY = dx * 0.4;
    final path = Path()..moveTo(x1, y1);
    for (var i = 0; i < segments; i++) {
      final sign = i.isEven ? 1.0 : -1.0;
      path.lineTo(
        x1 + dx * (i + 0.5) + perpX * sign,
        y1 + dy * (i + 0.5) + perpY * sign,
      );
    }
    path.lineTo(x2, y2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CharacterPainter oldDelegate) =>
      characterIndex != oldDelegate.characterIndex || level != oldDelegate.level;
}
