import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/data/repositories/avatar_repository.dart';
import 'package:magic_learning/models/avatar.dart';

final avatarProvider =
    NotifierProvider<AvatarNotifier, Avatar?>(AvatarNotifier.new);

class AvatarNotifier extends Notifier<Avatar?> {
  @override
  Avatar? build() {
    final repo = ref.watch(avatarRepositoryProvider);
    return repo.loadAvatar();
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
