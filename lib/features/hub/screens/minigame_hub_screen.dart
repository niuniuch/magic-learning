import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/hub/providers/progress_provider.dart';
import 'package:magic_learning/features/hub/widgets/avatar_status_bar.dart';
import 'package:magic_learning/features/hub/widgets/minigame_card.dart';
import 'package:magic_learning/models/minigame_config.dart';

class MiniGameHubScreen extends ConsumerWidget {
  const MiniGameHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarProvider);
    final progress = ref.watch(progressProvider);

    if (avatar == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/avatar/create');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AvatarStatusBar(avatar: avatar, progress: progress),
            const SizedBox(height: 8),
            // App-launcher style icon grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: MiniGameConfigs.all.length + 2,
                  itemBuilder: (context, index) {
                    // Game icons
                    if (index < MiniGameConfigs.all.length) {
                      final config = MiniGameConfigs.all[index];
                      final gameProgress = progress.miniGames[config.id];
                      return MiniGameCard(
                        config: config,
                        progress: gameProgress,
                        onTap: () => context.push('/game/${config.id}/modes'),
                      );
                    }
                    // Settings icon
                    if (index == MiniGameConfigs.all.length) {
                      return _UtilityIcon(
                        icon: Icons.settings,
                        label: 'Ustawienia',
                        color: Colors.grey.shade600,
                        onTap: () => context.push('/settings'),
                      );
                    }
                    // Test icon
                    return _UtilityIcon(
                      icon: Icons.bug_report,
                      label: 'Test',
                      color: Colors.grey.shade500,
                      onTap: () => context.push('/game/test'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UtilityIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _UtilityIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(icon, size: 32, color: color),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
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
