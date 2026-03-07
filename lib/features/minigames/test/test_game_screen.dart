import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/models/minigame_result.dart';

class TestGameScreen extends StatelessWidget {
  const TestGameScreen({super.key});

  void _finish(BuildContext context, int stars) {
    final capped = stars.clamp(0, 3);
    final result = MiniGameResult(
      gameId: 'test',
      modeId: 'test',
      correctAnswers: capped == 3 ? 9 : capped == 2 ? 7 : 5,
      totalQuestions: 10,
      starsEarned: stars,
      elapsedSeconds: 30,
      bestStreak: capped,
    );
    context.go('/game/result', extra: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Game')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ile gwiazdek chcesz zdobyć?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            for (final stars in [1, 2, 3, 10, 30])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: 240,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: stars <= 3
                          ? [Colors.orange, Colors.blue, Colors.green][stars - 1]
                          : stars == 30 ? Colors.red : Colors.purple,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                    onPressed: () => _finish(context, stars),
                    child: Text(stars <= 3
                        ? '${"⭐" * stars}  $stars ${stars == 1 ? "star" : "stars"}'
                        : '⭐x$stars  $stars stars'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
