import 'package:flutter/material.dart';
import 'package:magic_learning/core/constants/game_constants.dart';
import 'package:magic_learning/core/theme/app_theme.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_character.dart';
import 'package:magic_learning/models/avatar.dart';
import 'package:magic_learning/models/game_progress.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class AvatarStatusBar extends StatelessWidget {
  final Avatar avatar;
  final GameProgress progress;

  const AvatarStatusBar({
    super.key,
    required this.avatar,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final xpNeeded = GameConstants.xpForLevel(avatar.level);
    final xpProgress = avatar.xp / xpNeeded;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AvatarCharacter(
            characterIndex: avatar.characterIndex,
            size: 64,
            colorIndex: avatar.colorIndex,
            hat: avatar.activeHat,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  avatar.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${l10n.level} ${avatar.level}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: xpProgress.clamp(0.0, 1.0),
                          minHeight: 10,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.starColor, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.totalStars} ${l10n.stars}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
