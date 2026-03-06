import 'package:flutter/material.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_image.dart';

class AvatarCharacter extends StatelessWidget {
  final int characterIndex;
  final double size;
  final int colorIndex;
  final String? hat;
  final int level;
  final Map<String, int>? trackProgress;

  static const int characterCount = 6;

  const AvatarCharacter({
    super.key,
    required this.characterIndex,
    this.size = 80,
    this.colorIndex = 0,
    this.hat,
    this.level = 1,
    this.trackProgress,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarImage(
      characterIndex: characterIndex,
      size: size,
      colorIndex: colorIndex,
      hat: hat,
      level: level,
      trackProgress: trackProgress,
    );
  }
}
