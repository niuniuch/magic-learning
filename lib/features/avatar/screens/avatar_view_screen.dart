import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/core/constants/game_constants.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_full_body.dart';
import 'package:magic_learning/models/upgrade_track.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class AvatarViewScreen extends ConsumerWidget {
  const AvatarViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarProvider);
    final l10n = AppLocalizations.of(context)!;

    if (avatar == null) return const SizedBox.shrink();

    final charIdx = avatar.characterIndex % 6;
    final xpNeeded = GameConstants.xpForLevel(avatar.level);
    final xpProgress = xpNeeded > 0 ? avatar.xp / xpNeeded : 0.0;
    final bgColors = _backgroundGradients[charIdx];
    final config = CharacterUpgradeConfig.forCharacter(avatar.characterIndex);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: bgColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Text(
                avatar.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${l10n.level} ${avatar.level}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Track progress indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: config.tracks.map((track) {
                    final stage =
                        avatar.trackProgress[track.trackId.name] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Icon(
                            track.icon,
                            color: stage > 0
                                ? Colors.amber.shade300
                                : Colors.white.withValues(alpha: 0.3),
                            size: 20,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(4, (i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i < stage
                                        ? Colors.amber.shade300
                                        : Colors.white
                                            .withValues(alpha: 0.15),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              AvatarFullBody(
                characterIndex: avatar.characterIndex,
                width: 220,
                height: 380,
                level: avatar.level,
                trackProgress: avatar.trackProgress,
              ),
              const Spacer(),
              // XP bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: xpProgress.clamp(0.0, 1.0),
                        minHeight: 12,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.amber.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${avatar.xp} / $xpNeeded XP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  static const _backgroundGradients = [
    [Color(0xFF1A0533), Color(0xFF4A1A7A)], // mage
    [Color(0xFF2D0A3E), Color(0xFF7B2D8E)], // fairy
    [Color(0xFF0A1628), Color(0xFF0D3B66)], // merperson
    [Color(0xFF1A0A0A), Color(0xFF6B1010)], // superhero
    [Color(0xFF0A1A0A), Color(0xFF1B4332)], // alien
    [Color(0xFF0F1318), Color(0xFF2C3E50)], // robot
  ];
}
