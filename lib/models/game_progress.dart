import 'dart:convert';
import 'package:equatable/equatable.dart';

class RecentResult extends Equatable {
  final int starsEarned;
  final int timestamp; // millisecondsSinceEpoch

  const RecentResult({
    required this.starsEarned,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'starsEarned': starsEarned,
        'timestamp': timestamp,
      };

  factory RecentResult.fromJson(Map<String, dynamic> json) => RecentResult(
        starsEarned: json['starsEarned'] as int? ?? 0,
        timestamp: json['timestamp'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [starsEarned, timestamp];
}

class GameProgress extends Equatable {
  final Map<String, MiniGameProgress> miniGames;
  final int totalStars;
  final List<RecentResult> recentResults; // capped at 5

  const GameProgress({
    this.miniGames = const {},
    this.totalStars = 0,
    this.recentResults = const [],
  });

  /// Average stars over the most recent results (0.0 if empty).
  double get recentAverageStars {
    if (recentResults.isEmpty) return 0.0;
    final sum = recentResults.fold(0, (s, r) => s + r.starsEarned);
    return sum / recentResults.length;
  }

  GameProgress copyWith({
    Map<String, MiniGameProgress>? miniGames,
    int? totalStars,
    List<RecentResult>? recentResults,
  }) {
    return GameProgress(
      miniGames: miniGames ?? this.miniGames,
      totalStars: totalStars ?? this.totalStars,
      recentResults: recentResults ?? this.recentResults,
    );
  }

  Map<String, dynamic> toJson() => {
        'miniGames':
            miniGames.map((key, value) => MapEntry(key, value.toJson())),
        'totalStars': totalStars,
        'recentResults': recentResults.map((r) => r.toJson()).toList(),
      };

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    final miniGamesJson =
        (json['miniGames'] as Map<String, dynamic>?) ?? {};
    final recentJson = (json['recentResults'] as List<dynamic>?) ?? [];
    return GameProgress(
      miniGames: miniGamesJson.map((key, value) =>
          MapEntry(key, MiniGameProgress.fromJson(value as Map<String, dynamic>))),
      totalStars: json['totalStars'] as int? ?? 0,
      recentResults: recentJson
          .map((e) => RecentResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String encode() => jsonEncode(toJson());
  static GameProgress decode(String source) =>
      GameProgress.fromJson(jsonDecode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [miniGames, totalStars, recentResults];
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
