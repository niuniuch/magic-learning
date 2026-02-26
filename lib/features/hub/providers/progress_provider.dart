import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/data/repositories/progress_repository.dart';
import 'package:magic_learning/models/game_progress.dart';
import 'package:magic_learning/models/minigame_result.dart';

final progressProvider =
    NotifierProvider<ProgressNotifier, GameProgress>(ProgressNotifier.new);

class ProgressNotifier extends Notifier<GameProgress> {
  @override
  GameProgress build() {
    final repo = ref.watch(progressRepositoryProvider);
    return repo.loadProgress();
  }

  Future<void> recordResult(MiniGameResult result) async {
    final repo = ref.read(progressRepositoryProvider);
    final updated = repo.recordResult(state, result);
    await repo.saveProgress(updated);
    state = updated;
  }

  Future<void> resetProgress() async {
    final repo = ref.read(progressRepositoryProvider);
    await repo.deleteProgress();
    state = const GameProgress();
  }
}
