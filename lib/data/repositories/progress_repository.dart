import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/data/local/local_storage_service.dart';
import 'package:magic_learning/models/game_progress.dart';
import 'package:magic_learning/models/minigame_result.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(localStorageServiceProvider));
});

class ProgressRepository {
  final LocalStorageService _storage;

  ProgressRepository(this._storage);

  GameProgress loadProgress() {
    final data = _storage.getProgress();
    if (data == null) return const GameProgress();
    return GameProgress.decode(data);
  }

  Future<void> saveProgress(GameProgress progress) async {
    await _storage.saveProgress(progress.encode());
  }

  Future<void> deleteProgress() async {
    await _storage.deleteProgress();
  }

  GameProgress recordResult(GameProgress progress, MiniGameResult result) {
    final currentMiniGame = progress.miniGames[result.gameId] ??
        MiniGameProgress(gameId: result.gameId);

    final currentMode = currentMiniGame.modes[result.modeId] ??
        const ModeProgress();

    final updatedMode = currentMode.copyWith(
      timesPlayed: currentMode.timesPlayed + 1,
      bestScore: result.correctAnswers > currentMode.bestScore
          ? result.correctAnswers
          : currentMode.bestScore,
      totalCorrect: currentMode.totalCorrect + result.correctAnswers,
      totalQuestions: currentMode.totalQuestions + result.totalQuestions,
    );

    final updatedMiniGame = currentMiniGame.copyWith(
      modes: {...currentMiniGame.modes, result.modeId: updatedMode},
    );

    // Push recent result and cap at 5
    final recentResult = RecentResult(
      starsEarned: result.starsEarned,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    final updatedRecent = [
      ...progress.recentResults,
      recentResult,
    ];
    if (updatedRecent.length > 5) {
      updatedRecent.removeRange(0, updatedRecent.length - 5);
    }

    return progress.copyWith(
      miniGames: {...progress.miniGames, result.gameId: updatedMiniGame},
      totalStars: progress.totalStars + result.starsEarned,
      recentResults: updatedRecent,
    );
  }
}
