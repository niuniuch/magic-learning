import 'package:flutter_test/flutter_test.dart';
import 'package:magic_learning/models/avatar.dart';
import 'package:magic_learning/models/game_progress.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/features/minigames/addition/addition_game.dart';
import 'package:magic_learning/features/minigames/subtraction/subtraction_game.dart';
import 'package:magic_learning/features/minigames/multiplication/multiplication_game.dart';
import 'package:magic_learning/core/constants/game_constants.dart';

void main() {
  group('Avatar Model', () {
    test('serialization roundtrip', () {
      const avatar = Avatar(
        id: 'test-id',
        name: 'Kasia',
        characterIndex: 2,
        level: 3,
        xp: 15,
        unlockedUpgrades: ['hat_1', 'color_2'],
        activeHat: 'hat_1',
        colorIndex: 2,
      );

      final json = avatar.encode();
      final decoded = Avatar.decode(json);

      expect(decoded, equals(avatar));
      expect(decoded.name, 'Kasia');
      expect(decoded.level, 3);
      expect(decoded.unlockedUpgrades, ['hat_1', 'color_2']);
    });

    test('copyWith creates modified copy', () {
      const avatar = Avatar(
        id: 'test-id',
        name: 'Kasia',
        characterIndex: 0,
      );

      final leveled = avatar.copyWith(level: 1, xp: 5);
      expect(leveled.level, 1);
      expect(leveled.xp, 5);
      expect(leveled.name, 'Kasia');
    });
  });

  group('GameProgress Model', () {
    test('serialization roundtrip', () {
      const progress = GameProgress(
        miniGames: {
          'addition': MiniGameProgress(
            gameId: 'addition',
            modes: {
              'add_10': ModeProgress(
                timesPlayed: 5,
                bestScore: 9,
                totalCorrect: 40,
                totalQuestions: 50,
              ),
            },
          ),
        },
        totalStars: 42,
      );

      final json = progress.encode();
      final decoded = GameProgress.decode(json);

      expect(decoded.totalStars, 42);
      expect(decoded.miniGames['addition']!.modes['add_10']!.bestScore, 9);
    });

    test('ModeProgress accuracy calculation', () {
      const mode = ModeProgress(totalCorrect: 8, totalQuestions: 10);
      expect(mode.accuracy, 0.8);

      const empty = ModeProgress();
      expect(empty.accuracy, 0.0);
    });
  });

  group('Addition Game', () {
    late AdditionGame game;

    setUp(() {
      game = AdditionGame(
        config: MiniGameConfigs.all[0],
        mode: MiniGameConfigs.all[0].modes[0], // up to 10
      );
    });

    test('generates valid questions within range', () {
      for (var i = 0; i < 100; i++) {
        final q = game.generateQuestion();
        expect(q.operator, '+');
        expect(q.correctAnswer, q.operand1 + q.operand2);
        expect(q.correctAnswer, greaterThanOrEqualTo(0));
        expect(q.correctAnswer, lessThanOrEqualTo(20)); // a + b where both <= 10
        expect(q.choices, contains(q.correctAnswer));
        expect(q.choices.length, 4);
      }
    });
  });

  group('Subtraction Game', () {
    late SubtractionGame game;

    setUp(() {
      game = SubtractionGame(
        config: MiniGameConfigs.all[1],
        mode: MiniGameConfigs.all[1].modes[0], // up to 10
      );
    });

    test('generates non-negative results', () {
      for (var i = 0; i < 100; i++) {
        final q = game.generateQuestion();
        expect(q.operator, '-');
        expect(q.correctAnswer, q.operand1 - q.operand2);
        expect(q.correctAnswer, greaterThanOrEqualTo(0));
        expect(q.choices, contains(q.correctAnswer));
        expect(q.choices.length, 4);
      }
    });
  });

  group('Multiplication Game', () {
    late MultiplicationGame game;

    setUp(() {
      game = MultiplicationGame(
        config: MiniGameConfigs.all[2],
        mode: MiniGameConfigs.all[2].modes[0], // x2
      );
    });

    test('generates correct multiplication results', () {
      for (var i = 0; i < 100; i++) {
        final q = game.generateQuestion();
        expect(q.operator, '\u00D7');
        expect(q.operand2, 2);
        expect(q.correctAnswer, q.operand1 * q.operand2);
        expect(q.choices, contains(q.correctAnswer));
        expect(q.choices.length, 4);
      }
    });
  });

  group('Game Constants', () {
    test('XP for level increases', () {
      expect(GameConstants.xpForLevel(0), 10);
      expect(GameConstants.xpForLevel(1), 15);
      expect(GameConstants.xpForLevel(2), 20);
      expect(GameConstants.xpForLevel(5), 35);
    });
  });
}
