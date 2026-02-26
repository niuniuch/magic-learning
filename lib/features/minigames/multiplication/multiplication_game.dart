import 'dart:math';
import 'package:magic_learning/features/minigames/common/base_minigame.dart';

class MultiplicationGame extends BaseMinigame {
  final Random _random = Random();

  MultiplicationGame({required super.config, required super.mode});

  @override
  MathQuestion generateQuestion() {
    final multiplier = mode.multiplier ?? 2;
    final a = _random.nextInt(mode.maxValue) + 1;
    final answer = a * multiplier;

    return MathQuestion(
      operand1: a,
      operand2: multiplier,
      operator: '\u00D7',
      correctAnswer: answer,
      choices: _generateMultiplicationChoices(a, multiplier, answer),
    );
  }

  List<int> _generateMultiplicationChoices(int a, int multiplier, int correctAnswer) {
    final choices = <int>{correctAnswer};
    var attempts = 0;

    // Adjacent table entries: mult*(b±1), mult*(b±2)
    while (choices.length < 3 && attempts < 30) {
      attempts++;
      final offset = (_random.nextInt(3) + 1) * (_random.nextBool() ? 1 : -1);
      final wrong = multiplier * (a + offset);
      if (wrong > 0 && wrong != correctAnswer) choices.add(wrong);
    }

    // Off by 1-5
    attempts = 0;
    while (choices.length < 4 && attempts < 30) {
      attempts++;
      final wrong = correctAnswer + (_random.nextInt(5) + 1) * (_random.nextBool() ? 1 : -1);
      if (wrong > 0 && wrong != correctAnswer) choices.add(wrong);
    }

    var filler = correctAnswer + 1;
    while (choices.length < 4) {
      if (!choices.contains(filler) && filler > 0) choices.add(filler);
      filler++;
    }

    return (choices.toList()..shuffle(_random));
  }
}
