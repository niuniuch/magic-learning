import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Avatar
  String? getAvatar() => _prefs.getString('avatar');
  Future<bool> saveAvatar(String avatarJson) =>
      _prefs.setString('avatar', avatarJson);
  Future<bool> deleteAvatar() => _prefs.remove('avatar');

  // Game Progress
  String? getProgress() => _prefs.getString('game_progress');
  Future<bool> saveProgress(String progressJson) =>
      _prefs.setString('game_progress', progressJson);
  Future<bool> deleteProgress() => _prefs.remove('game_progress');

  // Settings
  bool getSoundEnabled() => _prefs.getBool('sound_enabled') ?? true;
  Future<bool> setSoundEnabled(bool enabled) =>
      _prefs.setBool('sound_enabled', enabled);

  // Full reset
  Future<bool> resetAll() => _prefs.clear();
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
});
