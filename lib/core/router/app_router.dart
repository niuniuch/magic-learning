import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/avatar/screens/avatar_creation_screen.dart';
import 'package:magic_learning/features/avatar/screens/avatar_upgrade_screen.dart';
import 'package:magic_learning/features/hub/screens/minigame_hub_screen.dart';
import 'package:magic_learning/features/minigames/common/mode_selection_screen.dart';
import 'package:magic_learning/features/minigames/common/game_play_screen.dart';
import 'package:magic_learning/features/minigames/common/buildable_picker_screen.dart';
import 'package:magic_learning/features/minigames/common/build_game_play_screen.dart';
import 'package:magic_learning/features/minigames/common/launch_animation_screen.dart';
import 'package:magic_learning/features/minigames/common/result_screen.dart';
import 'package:magic_learning/features/settings/screens/settings_screen.dart';
import 'package:magic_learning/models/buildable_model.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/models/minigame_result.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final avatar = ref.watch(avatarProvider);

  return GoRouter(
    initialLocation: avatar == null ? '/avatar/create' : '/hub',
    routes: [
      GoRoute(
        path: '/avatar/create',
        builder: (context, state) => const AvatarCreationScreen(),
      ),
      GoRoute(
        path: '/avatar/upgrade',
        builder: (context, state) => const AvatarUpgradeScreen(),
      ),
      GoRoute(
        path: '/hub',
        builder: (context, state) => const MiniGameHubScreen(),
      ),
      GoRoute(
        path: '/game/:gameId/modes',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          final config = MiniGameConfigs.all.firstWhere(
            (c) => c.id == gameId,
          );
          return ModeSelectionScreen(config: config);
        },
      ),
      GoRoute(
        path: '/game/:gameId/play/:modeId',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          final modeId = state.pathParameters['modeId']!;
          final config = MiniGameConfigs.all.firstWhere(
            (c) => c.id == gameId,
          );
          final mode = config.modes.firstWhere((m) => m.id == modeId);
          return GamePlayScreen(config: config, mode: mode);
        },
      ),
      GoRoute(
        path: '/game/:gameId/pick-buildable',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final config = extra['config'] as MiniGameConfig;
          final mode = extra['mode'] as GameMode;
          return BuildablePickerScreen(config: config, mode: mode);
        },
      ),
      GoRoute(
        path: '/game/:gameId/build-play',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final config = extra['config'] as MiniGameConfig;
          final mode = extra['mode'] as GameMode;
          final buildableId = extra['buildableId'] as String;
          return BuildGamePlayScreen(
            config: config,
            mode: mode,
            buildableId: buildableId,
          );
        },
      ),
      GoRoute(
        path: '/game/:gameId/launch',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final result = extra['result'] as MiniGameResult;
          final buildableModel = extra['buildableModel'] as BuildableModel;
          return LaunchAnimationScreen(
            result: result,
            buildableModel: buildableModel,
          );
        },
      ),
      GoRoute(
        path: '/game/result',
        builder: (context, state) {
          final result = state.extra as MiniGameResult;
          return ResultScreen(result: result);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Strona nie znaleziona: ${state.error}'),
      ),
    ),
  );
});
