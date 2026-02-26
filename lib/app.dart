import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_learning/l10n/app_localizations.dart';
import 'package:magic_learning/core/router/app_router.dart';
import 'package:magic_learning/core/theme/app_theme.dart';

class MagicLearningApp extends ConsumerWidget {
  const MagicLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Magiczne Uczenie',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('pl'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('pl'),
      ],
      routerConfig: router,
    );
  }
}
