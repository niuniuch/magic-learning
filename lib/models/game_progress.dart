import 'dart:convert';
import 'package:equatable/equatable.dart';

class GameProgress extends Equatable {
  final Map<String, MiniGameProgress> miniGames;
  final int totalStars;

  const GameProgress({
    this.miniGames = const {},
    this.totalStars = 0,
  });

  GameProgress copyWith({
    Map<String, MiniGameProgress>? miniGames,
    int? totalStars,
  }) {
    return GameProgress(
      miniGames: miniGames ?? this.miniGames,
      totalStars: totalStars ?? this.totalStars,
    );
  }

  Map<String, dynamic> toJson() => {
        'miniGames':
            miniGames.map((key, value) => MapEntry(key, value.toJson())),
        'totalStars': totalStars,
      };

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    final miniGamesJson =
        (json['miniGames'] as Map<String, dynamic>?) ?? {};
    return GameProgress(
      miniGames: miniGamesJson.map((key, value) =>
          MapEntry(key, MiniGameProgress.fromJson(value as Map<String, dynamic>))),
      totalStars: json['totalStars'] as int? ?? 0,
    );
  }

  String encode() => jsonEncode(toJson());
  static GameProgress decode(String source) =>
      GameProgress.fromJson(jsonDecode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [miniGames, totalStars];
}

class MiniGameProgress extends Equatable {
  final String gameId;
  final Map<String, ModeProgress> modes;

  const MiniGameProgress({
    required this.gameId,
    this.modes = const {},
  });

  MiniGameProgress copyWith({Map<String, ModeProgress>? modes}) {
    return MiniGameProgress(
      gameId: gameId,
      modes: modes ?? this.modes,
    );
  }

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'modes': modes.map((key, value) => MapEntry(key, value.toJson())),
      };

  factory MiniGameProgress.fromJson(Map<String, dynamic> json) {
    final modesJson = (json['modes'] as Map<String, dynamic>?) ?? {};
    return MiniGameProgress(
      gameId: json['gameId'] as String,
      modes: modesJson.map((key, value) =>
          MapEntry(key, ModeProgress.fromJson(value as Map<String, dynamic>))),
    );
  }

  @override
  List<Object?> get props => [gameId, modes];
}

class ModeProgress extends Equatable {
  final int timesPlayed;
  final int bestScore;
  final int totalCorrect;
  final int totalQuestions;

  const ModeProgress({
    this.timesPlayed = 0,
    this.bestScore = 0,
    this.totalCorrect = 0,
    this.totalQuestions = 0,
  });

  double get accuracy =>
      totalQuestions > 0 ? totalCorrect / totalQuestions : 0.0;

  ModeProgress copyWith({
    int? timesPlayed,
    int? bestScore,
    int? totalCorrect,
    int? totalQuestions,
  }) {
    return ModeProgress(
      timesPlayed: timesPlayed ?? this.timesPlayed,
      bestScore: bestScore ?? this.bestScore,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  Map<String, dynamic> toJson() => {
        'timesPlayed': timesPlayed,
        'bestScore': bestScore,
        'totalCorrect': totalCorrect,
        'totalQuestions': totalQuestions,
      };

  factory ModeProgress.fromJson(Map<String, dynamic> json) => ModeProgress(
        timesPlayed: json['timesPlayed'] as int? ?? 0,
        bestScore: json['bestScore'] as int? ?? 0,
        totalCorrect: json['totalCorrect'] as int? ?? 0,
        totalQuestions: json['totalQuestions'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [timesPlayed, bestScore, totalCorrect, totalQuestions];
}
