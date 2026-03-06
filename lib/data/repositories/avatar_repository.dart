import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/core/constants/game_constants.dart';
import 'package:magic_learning/data/local/local_storage_service.dart';
import 'package:magic_learning/models/avatar.dart';

final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  return AvatarRepository(ref.watch(localStorageServiceProvider));
});

class AvatarRepository {
  final LocalStorageService _storage;

  AvatarRepository(this._storage);

  Avatar? loadAvatar() {
    final data = _storage.getAvatar();
    if (data == null) return null;
    return Avatar.decode(data);
  }

  Future<void> saveAvatar(Avatar avatar) async {
    await _storage.saveAvatar(avatar.encode());
  }

  Future<void> deleteAvatar() async {
    await _storage.deleteAvatar();
  }

  Avatar addXp(Avatar avatar, int stars) {
    final newXp = avatar.xp + stars;
    final xpNeeded = GameConstants.xpForLevel(avatar.level);

    if (newXp >= xpNeeded && avatar.level < GameConstants.maxAvatarLevel) {
      final newLevel = avatar.level + 1;
      final earnedUpgrade = GameConstants.isUpgradeLevel(newLevel) ? 1 : 0;
      return avatar.copyWith(
        level: newLevel,
        xp: newXp - xpNeeded,
        pendingUpgrades: avatar.pendingUpgrades + earnedUpgrade,
      );
    }
    return avatar.copyWith(xp: newXp);
  }

  /// Grant retroactive pending upgrades for existing high-level avatars
  /// that have empty trackProgress (pre-upgrade-track saves).
  Avatar migrateIfNeeded(Avatar avatar) {
    if (avatar.trackProgress.isNotEmpty) return avatar;

    final expectedPoints =
        GameConstants.upgradePointsEarnedAtLevel(avatar.level);
    if (expectedPoints <= 0) return avatar;

    // All expected points become pending since no tracks have been upgraded
    if (avatar.pendingUpgrades >= expectedPoints) return avatar;

    return avatar.copyWith(pendingUpgrades: expectedPoints);
  }
}
