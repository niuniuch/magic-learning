import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_character.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class _Upgrade {
  final String id;
  final String emoji;
  final String label;

  const _Upgrade(this.id, this.emoji, this.label);
}

class AvatarUpgradeScreen extends ConsumerWidget {
  const AvatarUpgradeScreen({super.key});

  List<_Upgrade> _getAvailableUpgrades(int level, List<String> unlocked) {
    final all = [
      const _Upgrade('hat_1', '\u{1F451}', 'Korona'),
      const _Upgrade('hat_2', '\u{1F3A9}', 'Cylinder'),
      const _Upgrade('hat_3', '\u{1F452}', 'Kapelusz'),
      const _Upgrade('hat_4', '\u26D1\u{FE0F}', 'Hełm'),
      const _Upgrade('hat_5', '\u{1F393}', 'Biret'),
      const _Upgrade('color_1', '\u{1F308}', 'Różowy'),
      const _Upgrade('color_2', '\u{1F499}', 'Niebieski'),
      const _Upgrade('color_3', '\u{1F49A}', 'Zielony'),
      const _Upgrade('color_4', '\u{1F49B}', 'Żółty'),
      const _Upgrade('color_5', '\u2764\u{FE0F}', 'Czerwony'),
    ];
    return all.where((u) => !unlocked.contains(u.id)).take(3).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarProvider);
    final l10n = AppLocalizations.of(context)!;

    if (avatar == null) {
      return const SizedBox.shrink();
    }

    final upgrades =
        _getAvailableUpgrades(avatar.level, avatar.unlockedUpgrades);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                '\u{1F389} ${l10n.levelUp} \u{1F389}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.level} ${avatar.level}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 24),
              AvatarCharacter(
                characterIndex: avatar.characterIndex,
                size: 120,
                colorIndex: avatar.colorIndex,
                hat: avatar.activeHat,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.chooseUpgrade,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: upgrades.length,
                  itemBuilder: (context, index) {
                    final upgrade = upgrades[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        leading: Text(
                          upgrade.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                        title: Text(
                          upgrade.label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () async {
                          await ref
                              .read(avatarProvider.notifier)
                              .applyUpgrade(upgrade.id);
                          if (context.mounted) {
                            context.go('/hub');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
