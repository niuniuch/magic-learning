import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/core/audio/audio_manager.dart';
import 'package:magic_learning/core/constants/game_constants.dart';
import 'package:magic_learning/core/theme/app_theme.dart';
import 'package:magic_learning/features/minigames/addition/addition_game.dart';
import 'package:magic_learning/features/minigames/common/base_minigame.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/rocket_builder.dart';
import 'package:magic_learning/features/minigames/multiplication/multiplication_game.dart';
import 'package:magic_learning/features/minigames/subtraction/subtraction_game.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/models/minigame_result.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class GamePlayScreen extends ConsumerStatefulWidget {
  final MiniGameConfig config;
  final GameMode mode;

  const GamePlayScreen({
    super.key,
    required this.config,
    required this.mode,
  });

  @override
  ConsumerState<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends ConsumerState<GamePlayScreen> {
  late BaseMinigame _game;
  late MathQuestion _currentQuestion;
  int _questionIndex = 0;
  int _correctAnswers = 0;
  int _rocketPieces = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  bool _rocketComplete = false;

  @override
  void initState() {
    super.initState();
    _game = _createGame();
    _currentQuestion = _game.generateQuestion();
  }

  BaseMinigame _createGame() {
    switch (widget.config.type) {
      case MiniGameType.addition:
        return AdditionGame(config: widget.config, mode: widget.mode);
      case MiniGameType.subtraction:
        return SubtractionGame(config: widget.config, mode: widget.mode);
      case MiniGameType.multiplication:
        return MultiplicationGame(config: widget.config, mode: widget.mode);
      case MiniGameType.clockReading:
        // Clock games use the new BuildGamePlayScreen instead
        return AdditionGame(config: widget.config, mode: widget.mode);
    }
  }

  void _checkAnswer(int answer) {
    if (_selectedAnswer != null) return; // Already answered

    final correct = answer == _currentQuestion.correctAnswer;
    final audio = ref.read(audioManagerProvider);

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = correct;
      if (correct) {
        _correctAnswers++;
        _rocketPieces = (_rocketPieces + 1)
            .clamp(0, GameConstants.rocketPieces);
        audio.playCorrect();
      } else {
        _rocketPieces = (_rocketPieces - 1).clamp(0, GameConstants.rocketPieces);
        audio.playIncorrect();
      }

      if (_rocketPieces >= GameConstants.rocketPieces) {
        _rocketComplete = true;
        audio.playLaunch();
      }
    });

    // Auto advance after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      if (_questionIndex + 1 >= GameConstants.questionsPerRound) {
        _finishGame();
      } else {
        setState(() {
          _questionIndex++;
          _currentQuestion = _game.generateQuestion();
          _selectedAnswer = null;
          _isCorrect = null;
        });
      }
    });
  }

  void _finishGame() {
    final starsEarned = _correctAnswers;
    final result = MiniGameResult(
      gameId: widget.config.id,
      modeId: widget.mode.id,
      correctAnswers: _correctAnswers,
      totalQuestions: GameConstants.questionsPerRound,
      starsEarned: starsEarned,
    );

    context.go('/game/result', extra: result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
        title: Text(
          l10n.questionOf(
            _questionIndex + 1,
            GameConstants.questionsPerRound,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Rocket builder
              RocketBuilder(
                totalPieces: GameConstants.rocketPieces,
                currentPieces: _rocketPieces,
                isComplete: _rocketComplete,
              ),
              const Spacer(),
              // Question
              _QuestionDisplay(
                question: _currentQuestion,
                isCorrect: _isCorrect,
              ),
              const SizedBox(height: 32),
              // Answer choices
              _AnswerChoices(
                choices: _currentQuestion.choices,
                correctAnswer: _currentQuestion.correctAnswer,
                selectedAnswer: _selectedAnswer,
                onSelect: _checkAnswer,
              ),
              const Spacer(),
              // Feedback
              if (_isCorrect != null)
                _FeedbackBanner(
                  isCorrect: _isCorrect!,
                  correctAnswer: _currentQuestion.correctAnswer,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionDisplay extends StatelessWidget {
  final MathQuestion question;
  final bool? isCorrect;

  const _QuestionDisplay({required this.question, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    if (isCorrect == true) {
      bgColor = AppTheme.correctColor.withValues(alpha: 0.1);
    } else if (isCorrect == false) {
      bgColor = AppTheme.incorrectColor.withValues(alpha: 0.1);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        question.displayText,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _AnswerChoices extends StatelessWidget {
  final List<int> choices;
  final int correctAnswer;
  final int? selectedAnswer;
  final ValueChanged<int> onSelect;

  const _AnswerChoices({
    required this.choices,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: choices.map((choice) {
        Color bgColor;
        Color textColor = Colors.white;

        if (selectedAnswer == null) {
          bgColor = Theme.of(context).colorScheme.primary;
        } else if (choice == correctAnswer) {
          bgColor = AppTheme.correctColor;
        } else if (choice == selectedAnswer) {
          bgColor = AppTheme.incorrectColor;
        } else {
          bgColor = Colors.grey[400]!;
        }

        return SizedBox(
          width: 140,
          height: 64,
          child: ElevatedButton(
            onPressed: selectedAnswer == null ? () => onSelect(choice) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: textColor,
              disabledBackgroundColor: bgColor,
              disabledForegroundColor: textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              '$choice',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final int correctAnswer;

  const _FeedbackBanner({
    required this.isCorrect,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isCorrect ? AppTheme.correctColor : AppTheme.incorrectColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              isCorrect
                  ? l10n.correct
                  : '${l10n.incorrect} ($correctAnswer)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
