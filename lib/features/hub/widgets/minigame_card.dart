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
      case 'clockReading':
        return 'Zegar';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  config.color.withValues(alpha: 0.85),
                  config.color,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: config.color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    config.icon,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                if (totalPlayed > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$totalPlayed',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _getTitle(l10n),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
