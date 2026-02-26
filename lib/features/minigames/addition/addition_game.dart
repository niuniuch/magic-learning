import 'dart:math';
import 'package:magic_learning/features/minigames/common/base_minigame.dart';

class AdditionGame extends BaseMinigame {
  final Random _random = Random();

  AdditionGame({required super.config, required super.mode});

  @override
  MathQuestion generateQuestion() {
    final maxVal = mode.maxValue;
    final a = _random.nextInt(maxVal) + 1;
    final b = _random.nextInt(maxVal - a + 1);
    final answer = a + b;

    return MathQuestion(
      operand1: a,
      operand2: b,
      operator: '+',
      correctAnswer: answer,
      choices: _generateAdditionChoices(a, b, answer),
    );
  }

  List<int> _generateAdditionChoices(int a, int b, int correctAnswer) {
    final choices = <int>{correctAnswer};
    var attempts = 0;

    while (choices.length < 4 && attempts < 50) {
      attempts++;
      int wrong;
      final r = _random.nextDouble();
      if (r < 0.3) {
        // Off by 1-3
        wrong = correctAnswer + (_random.nextInt(3) + 1) * (_random.nextBool() ? 1 : -1);
      } else if (r < 0.6) {
        // Off by 10
        wrong = correctAnswer + 10 * (_random.nextBool() ? 1 : -1);
      } else if (r < 0.8) {
        // Nearby operand perturbation
        wrong = (a + _random.nextInt(5) - 2) + (b + _random.nextInt(5) - 2);
      } else {
        // a*b confusion
        wrong = a * b;
      }
      if (wrong > 0 && wrong != correctAnswer && wrong <= mode.maxValue) {
        choices.add(wrong);
      }
    }

    // Fallback
    var filler = correctAnswer + 1;
    while (choices.length < 4) {
      if (!choices.contains(filler) && filler > 0) choices.add(filler);
      filler++;
    }

    return (choices.toList()..shuffle(_random));
  }
}
