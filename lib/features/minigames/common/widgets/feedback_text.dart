import 'dart:math';
import 'package:flutter/material.dart';

class FeedbackText extends StatelessWidget {
  final bool? isCorrect;
  final int streak;
  final String? correctAnswerText;

  const FeedbackText({
    super.key,
    required this.isCorrect,
    this.streak = 0,
    this.correctAnswerText,
  });

  static final _praises = [
    'Super!',
    'Brawo!',
    'Ekstra!',
    'Bomba!',
    'Pięknie!',
    'Wow!',
    'Genialne!',
    'Rośnie!',
  ];

  static final _encouragements = [
    'Prawie!',
    'Następnym razem!',
    'Nie poddawaj się!',
    'Spróbuj jeszcze!',
  ];

  @override
  Widget build(BuildContext context) {
    if (isCorrect == null) return const SizedBox(height: 36);

    final random = Random();
    String text;
    Color color;

    if (isCorrect!) {
      text = _praises[random.nextInt(_praises.length)];
      if (streak >= 3) text += ' (\u00D7${streak >= 3 ? 2 : 1}!)';
      color = const Color(0xFF2ECC71);
    } else {
      text = _encouragements[random.nextInt(_encouragements.length)];
      if (correctAnswerText != null) text += ' \u2192 $correctAnswerText';
      color = const Color(0xFFE74C3C);
    }

    return SizedBox(
      height: 36,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
