import 'package:equatable/equatable.dart';

class MistakeRecord extends Equatable {
  final String questionText;
  final String givenAnswer;
  final String correctAnswer;

  const MistakeRecord({
    required this.questionText,
    required this.givenAnswer,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [questionText, givenAnswer, correctAnswer];
}

class MiniGameResult extends Equatable {
  final String gameId;
  final String modeId;
  final int correctAnswers;
  final int totalQuestions;
  final int starsEarned;
  final int elapsedSeconds;
  final int bestStreak;
  final String? buildableModelId;
  final List<MistakeRecord> mistakes;

  const MiniGameResult({
    required this.gameId,
    required this.modeId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.starsEarned,
    this.elapsedSeconds = 0,
    this.bestStreak = 0,
    this.buildableModelId,
    this.mistakes = const [],
  });

  double get accuracy =>
      totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;

  static int calculateStars(double accuracy) {
    if (accuracy >= 0.85) return 3;
    if (accuracy >= 0.65) return 2;
    if (accuracy >= 0.45) return 1;
    return 0;
  }

  @override
  List<Object?> get props => [
        gameId,
        modeId,
        correctAnswers,
        totalQuestions,
        starsEarned,
        elapsedSeconds,
        bestStreak,
        buildableModelId,
        mistakes,
      ];
}
