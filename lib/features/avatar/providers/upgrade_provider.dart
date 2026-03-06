import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/hub/providers/progress_provider.dart';
import 'package:magic_learning/models/upgrade_track.dart';

class UpgradeOption {
  final UpgradeTrackConfig track;
  final int currentStage; // 0-4
  final bool locked;

  const UpgradeOption({
    required this.track,
    required this.currentStage,
    this.locked = false,
  });

  bool get isMaxed => currentStage >= 4;
  int get nextStage => currentStage + 1;

  UpgradeStageConfig? get nextStageConfig =>
      isMaxed ? null : track.stages[currentStage]; // stages[0] = stage 1
}

final upgradeOptionsProvider = Provider<List<UpgradeOption>>((ref) {
  final avatar = ref.watch(avatarProvider);
  final progress = ref.watch(progressProvider);
  if (avatar == null) return [];

  final config = CharacterUpgradeConfig.forCharacter(avatar.characterIndex);
  final avgStars = progress.recentAverageStars;

  final options = <UpgradeOption>[];
  int nonMaxedCount = 0;

  for (final track in config.tracks) {
    final stage = avatar.trackProgress[track.trackId.name] ?? 0;
    if (stage < 4) nonMaxedCount++;
  }

  for (int i = 0; i < config.tracks.length; i++) {
    final track = config.tracks[i];
    final stage = avatar.trackProgress[track.trackId.name] ?? 0;
    if (stage >= 4) continue; // skip maxed tracks

    // Lock 3rd option if avg stars < 2.0, but not if only 2 tracks remain
    final isThirdOption = options.length == 2;
    final shouldLock =
        isThirdOption && nonMaxedCount > 2 && avgStars < 2.0;

    options.add(UpgradeOption(
      track: track,
      currentStage: stage,
      locked: shouldLock,
    ));
  }

  return options;
});
