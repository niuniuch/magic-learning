import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/core/audio/audio_manager.dart';
import 'package:magic_learning/core/constants/game_constants.dart';
import 'package:magic_learning/features/minigames/addition/addition_game.dart';
import 'package:magic_learning/features/minigames/clock/clock_game.dart';
import 'package:magic_learning/features/minigames/clock/clock_question_display.dart';
import 'package:magic_learning/features/minigames/common/base_minigame.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/buildable_widget.dart';
import 'package:magic_learning/features/minigames/common/widgets/answer_grid.dart';
import 'package:magic_learning/features/minigames/common/widgets/feedback_text.dart';
import 'package:magic_learning/features/minigames/common/widgets/stats_bar.dart';
import 'package:magic_learning/features/minigames/multiplication/multiplication_game.dart';
import 'package:magic_learning/features/minigames/subtraction/subtraction_game.dart';
import 'package:magic_learning/models/buildable_model.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/models/minigame_result.dart';

class BuildGamePlayScreen extends ConsumerStatefulWidget {
  final MiniGameConfig config;
  final GameMode mode;
  final String buildableId;

  const BuildGamePlayScreen({
    super.key,
    required this.config,
    required this.mode,
    required this.buildableId,
  });

  @override
  ConsumerState<BuildGamePlayScreen> createState() => _BuildGamePlayScreenState();
}

class _BuildGamePlayScreenState extends ConsumerState<BuildGamePlayScreen> {
  late BuildableModel _buildableModel;
  BaseMinigame? _mathGame;
  ClockGame? _clockGame;

  // Current question state
  String _questionText = '';
  String _correctAnswer = '';
  List<String> _choices = [];
  List<int> _clockHours = [];

  // Game state
  int _builtParts = 0;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _correctCount = 0;
  int _totalQuestions = 0;
  int _elapsedSeconds = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  bool _justAdded = false;
  bool _justRemoved = false;
  final List<MistakeRecord> _mistakes = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _buildableModel = BuildableModel.findById(widget.buildableId) ??
        BuildableModel.rockets.first;

    if (widget.config.type == MiniGameType.clockReading) {
      _clockGame = ClockGame(modeId: widget.mode.id);
    } else {
      _mathGame = _createMathGame();
    }

    _startTimer();
    _nextQuestion();
  }

  BaseMinigame _createMathGame() {
    switch (widget.config.type) {
      case MiniGameType.addition:
        return AdditionGame(config: widget.config, mode: widget.mode);
      case MiniGameType.subtraction:
        return SubtractionGame(config: widget.config, mode: widget.mode);
      case MiniGameType.multiplication:
        return MultiplicationGame(config: widget.config, mode: widget.mode);
      default:
        return AdditionGame(config: widget.config, mode: widget.mode);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  void _nextQuestion() {
    if (_builtParts >= GameConstants.rocketPieces) {
      _timer?.cancel();
      _goToLaunch();
      return;
    }

    if (_clockGame != null) {
      final q = _clockGame!.generateQuestion();
      setState(() {
        _questionText = q.questionText;
        _correctAnswer = q.correctAnswer;
        _choices = q.choices;
        _clockHours = q.clockHours;
        _selectedAnswer = null;
        _isCorrect = null;
        _justAdded = false;
        _justRemoved = false;
      });
    } else {
      final q = _mathGame!.generateQuestion();
      setState(() {
        _questionText = q.displayText;
        _correctAnswer = '${q.correctAnswer}';
        _choices = q.choices.map((c) => '$c').toList();
        _clockHours = [];
        _selectedAnswer = null;
        _isCorrect = null;
        _justAdded = false;
        _justRemoved = false;
      });
    }
    _totalQuestions++;
  }

  void _checkAnswer(String answer) {
    if (_selectedAnswer != null) return;

    final correct = answer == _correctAnswer;
    final audio = ref.read(audioManagerProvider);

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = correct;

      if (correct) {
        _correctCount++;
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
        final bonus = _streak >= GameConstants.streakBonusThreshold
            ? GameConstants.streakBonusMultiplier
            : 1;
        _score += bonus;
        _builtParts = (_builtParts + 1).clamp(0, GameConstants.rocketPieces);
        _justAdded = true;
        audio.playCorrect();

        if (_builtParts >= GameConstants.rocketPieces) {
          audio.playLaunch();
        }
      } else {
        _builtParts = (_builtParts - 1).clamp(0, GameConstants.rocketPieces);
        _streak = 0;
        _justRemoved = true;
        _mistakes.add(MistakeRecord(
          questionText: _questionText,
          givenAnswer: answer,
          correctAnswer: _correctAnswer,
        ));
        audio.playIncorrect();
      }
    });

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _goToLaunch() {
    final accuracy = _totalQuestions > 0 ? _correctCount / _totalQuestions : 0.0;
    final stars = MiniGameResult.calculateStars(accuracy);
    final result = MiniGameResult(
      gameId: widget.config.id,
      modeId: widget.mode.id,
      correctAnswers: _correctCount,
      totalQuestions: _totalQuestions,
      starsEarned: stars,
      elapsedSeconds: _elapsedSeconds,
      bestStreak: _bestStreak,
      buildableModelId: _buildableModel.id,
      mistakes: _mistakes,
    );

    context.push(
      '/game/${widget.config.id}/launch',
      extra: {
        'result': result,
        'buildableModel': _buildableModel,
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRocket = _buildableModel.type == BuildableType.rocket;
    final bgColor = isRocket ? const Color(0xFF0B0E1A) : const Color(0xFF1B1E2E);
    final isWide = MediaQuery.of(context).size.width >= 600;
    final isClock = widget.config.type == MiniGameType.clockReading;

    final nextPartName = _builtParts < _buildableModel.partNames.length
        ? _buildableModel.partNames[_builtParts]
        : '';

    return Theme(
      data: ThemeData.dark().copyWith(scaffoldBackgroundColor: bgColor),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildGameColumn(isClock, nextPartName)),
                      const SizedBox(width: 12),
                      _buildBuildablePanel(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildGameColumn(isClock, nextPartName)),
                      const SizedBox(width: 10),
                      _buildBuildablePanel(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameColumn(bool isClock, String nextPartName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Stats bar
        StatsBar(
          score: _score,
          streak: _streak,
          parts: _builtParts,
          totalParts: GameConstants.rocketPieces,
          elapsedSeconds: _elapsedSeconds,
        ),
        const SizedBox(height: 10),
        // Question display
        if (isClock && _clockHours.isNotEmpty)
          ClockQuestionDisplay(
            question: ClockQuestion(
              questionText: _questionText,
              correctAnswer: _correctAnswer,
              choices: _choices,
              clockHours: _clockHours,
            ),
          )
        else
          _MathQuestionCard(
            questionText: _questionText,
            isCorrect: _isCorrect,
          ),
        if (nextPartName.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Następna część: $nextPartName',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4)),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 10),
        // Answer grid
        AnswerGrid(
          choices: _choices,
          correctAnswer: _correctAnswer,
          selectedAnswer: _selectedAnswer,
          onSelect: _checkAnswer,
        ),
        const SizedBox(height: 6),
        // Feedback
        FeedbackText(
          isCorrect: _isCorrect,
          streak: _streak,
          correctAnswerText: _isCorrect == false ? _correctAnswer : null,
        ),
      ],
    );
  }

  Widget _buildBuildablePanel() {
    return SizedBox(
      width: 120,
      child: BuildableWidget(
        model: _buildableModel,
        builtParts: _builtParts,
        justAdded: _justAdded,
        justRemoved: _justRemoved,
      ),
    );
  }
}

class _MathQuestionCard extends StatelessWidget {
  final String questionText;
  final bool? isCorrect;

  const _MathQuestionCard({required this.questionText, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF131836),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        questionText,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
