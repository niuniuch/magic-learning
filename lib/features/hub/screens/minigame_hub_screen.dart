import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/hub/providers/progress_provider.dart';
import 'package:magic_learning/features/hub/widgets/avatar_status_bar.dart';
import 'package:magic_learning/features/hub/widgets/minigame_card.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class MiniGameHubScreen extends ConsumerWidget {
  const MiniGameHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarProvider);
    final progress = ref.watch(progressProvider);
    final l10n = AppLocalizations.of(context)!;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.miniGameHub,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.settings, size: 28),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: MiniGameConfigs.all.length,
                  itemBuilder: (context, index) {
                    final config = MiniGameConfigs.all[index];
                    final gameProgress = progress.miniGames[config.id];
                    return MiniGameCard(
                      config: config,
                      progress: gameProgress,
                      onTap: () => context.push('/game/${config.id}/modes'),
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
