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
      return avatar.copyWith(
        level: avatar.level + 1,
        xp: newXp - xpNeeded,
      );
    }
    return avatar.copyWith(xp: newXp);
  }
}
