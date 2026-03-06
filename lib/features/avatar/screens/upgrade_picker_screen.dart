import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/avatar/providers/upgrade_provider.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_full_body.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_image.dart';
import 'package:magic_learning/models/upgrade_track.dart';

class UpgradePickerScreen extends ConsumerWidget {
  const UpgradePickerScreen({super.key});

  static const _backgroundGradients = [
    [Color(0xFF1A0533), Color(0xFF4A1A7A)], // mage
    [Color(0xFF2D0A3E), Color(0xFF7B2D8E)], // fairy
    [Color(0xFF0A1628), Color(0xFF0D3B66)], // merperson
    [Color(0xFF1A0A0A), Color(0xFF6B1010)], // superhero
    [Color(0xFF0A1A0A), Color(0xFF1B4332)], // alien
    [Color(0xFF0F1318), Color(0xFF2C3E50)], // robot
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarProvider);
    final options = ref.watch(upgradeOptionsProvider);

    if (avatar == null) return const SizedBox.shrink();

    final charIdx = avatar.characterIndex % 6;
    final bgColors = _backgroundGradients[charIdx];

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
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Character at top
              AvatarFullBody(
                characterIndex: avatar.characterIndex,
                width: 120,
                height: 200,
                level: avatar.level,
                trackProgress: avatar.trackProgress,
              ),
              const SizedBox(height: 12),
              const Text(
                'Wybierz ulepszenie!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pozostało: ${avatar.pendingUpgrades}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              // Track option cards
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return _TrackCard(
                      option: option,
                      characterIndex: avatar.characterIndex,
                      bgColors: bgColors,
                      onTap: option.locked
                          ? null
                          : () async {
                              final trackId = option.track.trackId;
                              final nextStage = option.nextStage;
                              final config =
                                  CharacterUpgradeConfig.forCharacter(
                                      avatar.characterIndex);
                              final trackConfig = config.tracks.firstWhere(
                                  (t) => t.trackId == trackId);
                              final stageConfig =
                                  trackConfig.stages[nextStage - 1];

                              await ref
                                  .read(avatarProvider.notifier)
                                  .applyTrackUpgrade(trackId);

                              if (context.mounted) {
                                context.go('/avatar/upgrade', extra: {
                                  'trackId': trackId.name,
                                  'stageName': stageConfig.name,
                                  'stageDescription': stageConfig.description,
                                  'trackName': trackConfig.name,
                                });
                              }
                            },
                    );
                  },
                ),
              ),
              // Skip button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: TextButton(
                  onPressed: () => context.go('/hub'),
                  child: Text(
                    'Później',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackCard extends StatelessWidget {
  final UpgradeOption option;
  final int characterIndex;
  final List<Color> bgColors;
  final VoidCallback? onTap;

  const _TrackCard({
    required this.option,
    required this.characterIndex,
    required this.bgColors,
    required this.onTap,
  });

  Widget _buildTrackPreview(UpgradeTrackConfig track) {
    final previewPath = AvatarImage.trackAssetPath(
      characterIndex,
      track.trackId.name,
      option.nextStage,
    );

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: option.locked
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.amber.shade300.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        previewPath,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => Icon(
          track.icon,
          color: option.locked
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.amber.shade300,
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final track = option.track;
    final nextStageConfig = option.nextStageConfig;
    final currentStageName = option.currentStage > 0
        ? track.stages[option.currentStage - 1].name
        : 'Brak';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: option.locked
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.amber.shade300.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Track preview image or icon fallback
                _buildTrackPreview(track),
                const SizedBox(width: 14),
                // Track info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: option.locked
                              ? Colors.white.withValues(alpha: 0.4)
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (nextStageConfig != null)
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: option.locked
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                            children: [
                              TextSpan(text: '$currentStageName  '),
                              TextSpan(
                                text: '\u2192',
                                style: TextStyle(
                                  color: Colors.amber.shade300,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: '  ${nextStageConfig.name}'),
                            ],
                          ),
                        ),
                      if (nextStageConfig != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            nextStageConfig.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: option.locked
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Stage progress dots
                Column(
                  children: List.generate(4, (i) {
                    final filled = i < option.currentStage;
                    final isNext = i == option.currentStage;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? Colors.amber.shade300
                              : isNext
                                  ? Colors.amber.shade300
                                      .withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          // Lock overlay
          if (option.locked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.white54, size: 28),
                      SizedBox(height: 4),
                      Text(
                        'Zdobądź więcej gwiazdek!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
