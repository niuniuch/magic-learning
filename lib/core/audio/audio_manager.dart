import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioManagerProvider = Provider<AudioManager>((ref) {
  final manager = AudioManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

class AudioManager {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _soundEnabled = true;

  bool get soundEnabled => _soundEnabled;

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  Future<void> playCorrect() => _play('audio/correct.mp3');
  Future<void> playIncorrect() => _play('audio/incorrect.mp3');
  Future<void> playLevelUp() => _play('audio/level_up.mp3');
  Future<void> playLaunch() => _play('audio/launch.mp3');
  Future<void> playTap() => _play('audio/tap.mp3');
  Future<void> playCountdown() => _play('audio/countdown.mp3');
  Future<void> playStreakBonus() => _play('audio/streak.mp3');

  Future<void> _play(String assetPath) async {
    if (!_soundEnabled) return;
    try {
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Audio files may not exist yet - fail silently
    }
  }

  void dispose() {
    _sfxPlayer.dispose();
  }
}
