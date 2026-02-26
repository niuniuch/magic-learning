import 'package:flutter/material.dart';
import 'package:magic_learning/features/avatar/painters/character_painter.dart';

class AvatarCharacter extends StatelessWidget {
  final int characterIndex;
  final double size;
  final int colorIndex;
  final String? hat;
  final int level;

  static const int characterCount = 6;

  static const List<Color> _backgroundColors = [
    Color(0xFFE8D5FF),
    Color(0xFFFFD5E5),
    Color(0xFFD5F5FF),
    Color(0xFFD5FFE0),
    Color(0xFFFFF5D5),
    Color(0xFFFFD5D5),
  ];

  static const List<Color> _borderColors = [
    Color(0xFF9B59B6),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFF44336),
  ];

  const AvatarCharacter({
    super.key,
    required this.characterIndex,
    this.size = 80,
    this.colorIndex = 0,
    this.hat,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = _borderColors[characterIndex % _borderColors.length];
    final bgColor = _backgroundColors[colorIndex % _backgroundColors.length];

    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Padding(
            // Shift the character up slightly so the head/torso is visible
            padding: EdgeInsets.only(top: size * 0.05),
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 200,
                // Show roughly the top 60% of the character (head + torso)
                height: 220,
                child: CustomPaint(
                  painter: CharacterPainter(
                    characterIndex: characterIndex,
                    level: level,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
