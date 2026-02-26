import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/core/audio/audio_manager.dart';
import 'package:magic_learning/core/constants/game_constants.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/hub/providers/progress_provider.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _parentalGateUnlocked = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final audio = ref.watch(audioManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Sound toggle
              Card(
                child: ListTile(
                  leading: Icon(
                    audio.soundEnabled ? Icons.volume_up : Icons.volume_off,
                    size: 28,
                  ),
                  title: Text(
                    audio.soundEnabled ? 'Dźwięk włączony' : 'Dźwięk wyłączony',
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: Switch(
                    value: audio.soundEnabled,
                    onChanged: (_) => setState(() => audio.toggleSound()),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Parental gate section
              Card(
                child: ListTile(
                  leading: const Icon(Icons.lock, size: 28),
                  title: Text(
                    l10n.parentalGate,
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(
                    _parentalGateUnlocked
                        ? Icons.lock_open
                        : Icons.arrow_forward_ios,
                  ),
                  onTap: _parentalGateUnlocked
                      ? null
                      : () => _showParentalGate(context, l10n),
                ),
              ),
              if (_parentalGateUnlocked) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _showResetConfirm(context, l10n),
                    icon: const Icon(Icons.delete_forever),
                    label: Text(
                      l10n.resetProgress,
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showParentalGate(BuildContext context, AppLocalizations l10n) {
    final random = Random();
    final a = random.nextInt(GameConstants.parentalGateMaxMultiplier -
            GameConstants.parentalGateMinMultiplier +
            1) +
        GameConstants.parentalGateMinMultiplier;
    final b = random.nextInt(GameConstants.parentalGateMaxMultiplier -
            GameConstants.parentalGateMinMultiplier +
            1) +
        GameConstants.parentalGateMinMultiplier;
    final correctAnswer = a * b;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.parentalGate),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.parentalGateQuestion(a, b),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.back),
          ),
          ElevatedButton(
            onPressed: () {
              final answer = int.tryParse(controller.text);
              if (answer == correctAnswer) {
                Navigator.pop(ctx);
                setState(() => _parentalGateUnlocked = true);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirm(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetProgress),
        content: Text(l10n.resetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(progressProvider.notifier).resetProgress();
              await ref.read(avatarProvider.notifier).deleteAvatar();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) context.go('/avatar/create');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }
}
