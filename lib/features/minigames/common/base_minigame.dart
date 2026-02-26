import 'dart:math';
import 'package:magic_learning/models/minigame_config.dart';

class MathQuestion {
  final int operand1;
  final int operand2;
  final String operator;
  final int correctAnswer;
  final List<int> choices;

  const MathQuestion({
    required this.operand1,
    required this.operand2,
    required this.operator,
    required this.correctAnswer,
    required this.choices,
  });

  String get displayText => '$operand1 $operator $operand2 = ?';
}

abstract class BaseMinigame {
  final MiniGameConfig config;
  final GameMode mode;
  final Random _random = Random();

  BaseMinigame({required this.config, required this.mode});

  MathQuestion generateQuestion();

  List<int> generateChoices(int correctAnswer) {
    final choices = <int>{correctAnswer};
    final range = (correctAnswer.abs() * 0.5).ceil().clamp(3, 20);
    var attempts = 0;

    while (choices.length < 4 && attempts < 100) {
      attempts++;
      final offset = _random.nextInt(range * 2 + 1) - range;
      final wrong = correctAnswer + offset;
      if (wrong != correctAnswer && wrong >= 0) {
        choices.add(wrong);
      }
    }

    // Fallback: fill with sequential values if still not enough
    var filler = correctAnswer + 1;
    while (choices.length < 4) {
      if (!choices.contains(filler) && filler >= 0) {
        choices.add(filler);
      }
      filler++;
    }

    final list = choices.toList()..shuffle(_random);
    return list;
  }
}
