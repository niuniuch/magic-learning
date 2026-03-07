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
    int xp = avatar.xp + stars;
    int level = avatar.level;
    int upgrades = avatar.pendingUpgrades;

    while (level < GameConstants.maxAvatarLevel) {
      final xpNeeded = GameConstants.xpForLevel(level);
      if (xp < xpNeeded) break;
      xp -= xpNeeded;
      level++;
      if (GameConstants.isUpgradeLevel(level)) {
        upgrades++;
      }
    }

    return avatar.copyWith(level: level, xp: xp, pendingUpgrades: upgrades);
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
