import 'package:flutter/material.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/models/game_progress.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class MiniGameCard extends StatelessWidget {
  final MiniGameConfig config;
  final MiniGameProgress? progress;
  final VoidCallback onTap;

  const MiniGameCard({
    super.key,
    required this.config,
    required this.progress,
    required this.onTap,
  });

  String _getTitle(AppLocalizations l10n) {
    switch (config.id) {
      case 'addition':
        return l10n.addition;
      case 'subtraction':
        return l10n.subtraction;
      case 'multiplication':
        return l10n.multiplication;
      default:
        return config.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalPlayed = progress?.modes.values
            .fold<int>(0, (sum, m) => sum + m.timesPlayed) ??
        0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                config.color.withValues(alpha: 0.8),
                config.color,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  config.icon,
                  size: 56,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  _getTitle(l10n),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (totalPlayed > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\u{2B50} $totalPlayed',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
