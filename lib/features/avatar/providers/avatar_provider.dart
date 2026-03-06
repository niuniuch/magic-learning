import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/data/repositories/avatar_repository.dart';
import 'package:magic_learning/models/avatar.dart';
import 'package:magic_learning/models/upgrade_track.dart';

final avatarProvider =
    NotifierProvider<AvatarNotifier, Avatar?>(AvatarNotifier.new);

class AvatarNotifier extends Notifier<Avatar?> {
  @override
  Avatar? build() {
    final repo = ref.watch(avatarRepositoryProvider);
    final avatar = repo.loadAvatar();
    if (avatar == null) return null;
    return repo.migrateIfNeeded(avatar);
  }

  Future<void> createAvatar(Avatar avatar) async {
    final repo = ref.read(avatarRepositoryProvider);
    await repo.saveAvatar(avatar);
    state = avatar;
  }

  Future<void> addXp(int stars) async {
    if (state == null) return;
    final repo = ref.read(avatarRepositoryProvider);
    final updated = repo.addXp(state!, stars);
    await repo.saveAvatar(updated);
    state = updated;
  }

  bool checkLevelUp(int previousLevel) {
    return state != null && state!.level > previousLevel;
  }

  Future<void> applyTrackUpgrade(UpgradeTrackId trackId) async {
    if (state == null || state!.pendingUpgrades <= 0) return;
    final repo = ref.read(avatarRepositoryProvider);
    final currentStage = state!.trackProgress[trackId.name] ?? 0;
    if (currentStage >= 4) return; // already maxed

    final updated = state!.copyWith(
      trackProgress: {
        ...state!.trackProgress,
        trackId.name: currentStage + 1,
      },
      pendingUpgrades: state!.pendingUpgrades - 1,
    );
    await repo.saveAvatar(updated);
    state = updated;
  }

  Future<void> applyUpgrade(String upgradeId) async {
    if (state == null) return;
    final repo = ref.read(avatarRepositoryProvider);
    final updated = state!.copyWith(
      unlockedUpgrades: [...state!.unlockedUpgrades, upgradeId],
      activeHat: upgradeId.startsWith('hat_') ? upgradeId : state!.activeHat,
      colorIndex:
          upgradeId.startsWith('color_')
              ? int.tryParse(upgradeId.split('_').last) ?? state!.colorIndex
              : state!.colorIndex,
    );
    await repo.saveAvatar(updated);
    state = updated;
  }

  Future<void> deleteAvatar() async {
    final repo = ref.read(avatarRepositoryProvider);
    await repo.deleteAvatar();
    state = null;
  }
}
