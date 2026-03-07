import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/core/audio/audio_manager.dart';
import 'package:magic_learning/core/constants/game_constants.dart';
import 'package:magic_learning/core/theme/app_theme.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/hub/providers/progress_provider.dart';
import 'package:magic_learning/models/buildable_model.dart';
import 'package:magic_learning/models/minigame_result.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final MiniGameResult result;

  const ResultScreen({super.key, required this.result});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _starsPopupController;
  late final AnimationController _xpBarController;

  bool _saved = false;
  bool _leveledUp = false;
  bool _hasUpgradeAvailable = false;
  bool _animationDone = false;

  double _xpBarFrom = 0.0;
  double _xpBarTo = 0.0;
  int _levelFrom = 0;
  int _levelTo = 0;

  int get _starsEarned => widget.result.starsEarned.clamp(0, 3);

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    );

    _starsPopupController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _xpBarController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Chain: popup complete → xp bar → done
    _starsPopupController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _xpBarController.forward();
      }
    });
    _xpBarController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _animationDone = true);
        if (_leveledUp) {
          ref.read(audioManagerProvider).playLevelUp();
        }
      }
    });

    _entryController.forward();

    if (_starsEarned > 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _starsPopupController.forward();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _xpBarController.forward();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _saveResults());
  }

  Future<void> _saveResults() async {
    if (_saved) return;
    _saved = true;

    final avatar = ref.read(avatarProvider);
    final prevLevel = avatar?.level ?? 0;
    final prevXp = avatar?.xp ?? 0;
    final prevXpNeeded = GameConstants.xpForLevel(prevLevel);

    _levelFrom = prevLevel;
    _xpBarFrom = prevXpNeeded > 0 ? prevXp / prevXpNeeded : 0.0;

    await ref.read(progressProvider.notifier).recordResult(widget.result);
    await ref.read(avatarProvider.notifier).addXp(widget.result.starsEarned);

    final newAvatar = ref.read(avatarProvider);
    final newLevel = newAvatar?.level ?? 0;
    final newXp = newAvatar?.xp ?? 0;
    final newXpNeeded = GameConstants.xpForLevel(newLevel);

    _levelTo = newLevel;
    _xpBarTo = newXpNeeded > 0 ? newXp / newXpNeeded : 0.0;

    if (newLevel > prevLevel) {
      _leveledUp = true;
    }
    _hasUpgradeAvailable = (newAvatar?.pendingUpgrades ?? 0) > 0;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _entryController.dispose();
    _starsPopupController.dispose();
    _xpBarController.dispose();
    super.dispose();
  }

  double _xpProgress(double t) {
    if (!_leveledUp) {
      return _xpBarFrom + (_xpBarTo - _xpBarFrom) * t;
    }
    if (t >= 1.0) return _xpBarTo;

    final levelsGained = _levelTo - _levelFrom;
    // Total segments: fill first bar to 1.0, then N-1 full bars, then fill final bar
    final totalWork = (1.0 - _xpBarFrom) + (levelsGained - 1).clamp(0, 999) + _xpBarTo;
    if (totalWork <= 0) return _xpBarTo;

    var remaining = t * totalWork;

    // First segment: fill current bar to 1.0
    final firstFill = 1.0 - _xpBarFrom;
    if (remaining <= firstFill) {
      return _xpBarFrom + remaining;
    }
    remaining -= firstFill;

    // Middle segments: full bar fills (each = 1.0 of work)
    final middleBars = levelsGained - 1;
    if (remaining <= middleBars) {
      return remaining - remaining.floor().toDouble();
    }
    remaining -= middleBars;

    // Final segment: fill to _xpBarTo
    return (_xpBarTo > 0) ? (remaining / _xpBarTo).clamp(0.0, 1.0) * _xpBarTo : 0.0;
  }

  int _displayLevel(double t) {
    if (!_leveledUp) return _levelTo;
    if (t >= 1.0) return _levelTo;

    final levelsGained = _levelTo - _levelFrom;
    final totalWork = (1.0 - _xpBarFrom) + (levelsGained - 1).clamp(0, 999) + _xpBarTo;
    if (totalWork <= 0) return _levelTo;

    var remaining = t * totalWork;
    final firstFill = 1.0 - _xpBarFrom;
    if (remaining <= firstFill) return _levelFrom;
    remaining -= firstFill;

    final levelsInMiddle = remaining.floor().clamp(0, levelsGained - 1);
    return _levelFrom + 1 + levelsInMiddle;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accuracy = widget.result.accuracy;
    final starsEarned = _starsEarned;
    final hasBuildable = widget.result.buildableModelId != null;
    final buildable = hasBuildable
        ? BuildableModel.findById(widget.result.buildableModelId!)
        : null;

    final isDark = hasBuildable;
    final isRocket = buildable?.type == BuildableType.rocket;

    final bgColor = isDark
        ? (isRocket ? const Color(0xFF0B0E1A) : const Color(0xFF1B1E2E))
        : null;
    final cardColor = isDark ? const Color(0xFF131836) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D2D2D);

    return Theme(
      data: isDark
          ? ThemeData.dark().copyWith(scaffoldBackgroundColor: bgColor)
          : Theme.of(context),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Layer 0: main scrollable content
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(
                        accuracy >= 0.7 ? '\u{1F389}' : '\u{1F4AA}',
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      buildable != null
                          ? (isRocket
                              ? '${buildable.name} w kosmosie!'
                              : '${buildable.name} na mecie!')
                          : l10n.greatJob,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFFFC947) : textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final thresholds = [0.45, 0.65, 0.85];
                        final earned = accuracy >= thresholds[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            earned ? Icons.star : Icons.star_border,
                            color: AppTheme.starColor,
                            size: 42,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Stats card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.8,
                            children: [
                              _StatBox(
                                value: '${widget.result.correctAnswers}/${widget.result.totalQuestions}',
                                label: 'Poprawne',
                                textColor: textColor,
                                isDark: isDark,
                              ),
                              _StatBox(
                                value: '${widget.result.elapsedSeconds}s',
                                label: 'Czas',
                                textColor: textColor,
                                isDark: isDark,
                              ),
                              _StatBox(
                                value: '${widget.result.bestStreak}',
                                label: 'Najlepsza seria',
                                textColor: textColor,
                                isDark: isDark,
                              ),
                              _StatBox(
                                value: '${widget.result.totalQuestions}',
                                label: 'Pytań łącznie',
                                textColor: textColor,
                                isDark: isDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.starsEarned(starsEarned),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.starColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // XP Progress Bar
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: _xpBarController,
                      builder: (context, _) {
                        final t = _xpBarController.value;
                        final progress = _xpProgress(t).clamp(0.0, 1.0);
                        final level = _displayLevel(t);
                        final xpNeeded = GameConstants.xpForLevel(level);
                        final currentXp = (progress * xpNeeded).round();
                        return _XpProgressBar(
                          progress: progress,
                          level: level,
                          currentXp: currentXp,
                          xpNeeded: xpNeeded,
                          isDark: isDark,
                          textColor: textColor,
                        );
                      },
                    ),
                    // Mistakes review
                    if (widget.result.mistakes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Powtórz to jeszcze raz:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFFE94560) : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...widget.result.mistakes.map((m) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.red.withValues(alpha: 0.1)
                                          : Colors.red.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border(
                                        left: BorderSide(
                                          color: isDark ? const Color(0xFFE94560) : Colors.red,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(fontSize: 14, color: textColor),
                                        children: [
                                          TextSpan(text: '${m.questionText} = '),
                                          TextSpan(
                                            text: m.givenAnswer,
                                            style: const TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const TextSpan(text: ' \u2192 '),
                                          TextSpan(
                                            text: m.correctAnswer,
                                            style: const TextStyle(
                                              color: Color(0xFF2ECC71),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                    // Level up banner (gated behind animation)
                    if (_leveledUp && _animationDone) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade300, Colors.blue.shade300],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('\u{2B50}', style: TextStyle(fontSize: 28)),
                            const SizedBox(width: 8),
                            Text(
                              '${l10n.levelUp} ${l10n.level} $_levelTo!',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('\u{2B50}', style: TextStyle(fontSize: 28)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Buttons (gated behind animation)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: _animationDone
                                  ? () => context.go('/hub')
                                  : null,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark ? Colors.white : null,
                                side: BorderSide(
                                  color: isDark ? Colors.white38 : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              child: Text(
                                'Wróć do menu',
                                style: TextStyle(fontSize: 15, color: isDark ? Colors.white : null),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _animationDone
                                  ? () {
                                      if (_hasUpgradeAvailable) {
                                        context.go('/avatar/upgrade-pick');
                                      } else {
                                        context.go('/hub');
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? const Color(0xFFFFC947)
                                    : Theme.of(context).colorScheme.primary,
                                foregroundColor: isDark ? const Color(0xFF0B0E1A) : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                _hasUpgradeAvailable ? '\u{2B50} Nowe ulepszenie!' : 'ZAGRAJ JESZCZE RAZ',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Layer 1: Star popup overlay
              if (starsEarned > 0)
                AnimatedBuilder(
                  animation: _starsPopupController,
                  builder: (context, _) => _buildStarPopup(starsEarned, isDark),
                ),
              // Layer 2: Flying stars
              if (starsEarned > 0)
                AnimatedBuilder(
                  animation: _starsPopupController,
                  builder: (context, _) => _buildFlyingStars(starsEarned),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarPopup(int stars, bool isDark) {
    final v = _starsPopupController.value;

    // Popup opacity: fade in 0→0.111, hold 0.111→0.5, fade out 0.5→0.611
    double opacity;
    if (v < 0.111) {
      opacity = v / 0.111;
    } else if (v < 0.5) {
      opacity = 1.0;
    } else if (v < 0.611) {
      opacity = 1.0 - (v - 0.5) / 0.111;
    } else {
      return const SizedBox.shrink();
    }

    // Popup scale: elastic bounce in over 0→0.167
    final scale = v < 0.167
        ? 0.5 + 0.5 * Curves.elasticOut.transform(v / 0.167)
        : 1.0;

    return IgnorePointer(
      child: Center(
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF1A1F3D) : Colors.white)
                    .withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.starColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Zdobyte gwiazdki!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFFFFC947)
                          : const Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(stars, (i) {
                      // Each star bounces in staggered by ~200ms
                      final starStart = 0.111 + i * 0.111;
                      final starEnd = (starStart + 0.222).clamp(0.0, 1.0);
                      double s;
                      if (v < starStart) {
                        s = 0.0;
                      } else if (v < starEnd) {
                        s = Curves.elasticOut.transform(
                          (v - starStart) / (starEnd - starStart),
                        );
                      } else {
                        s = 1.0;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Transform.scale(
                          scale: s,
                          child: Icon(
                            Icons.star,
                            color: AppTheme.starColor,
                            size: 48,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlyingStars(int stars) {
    final v = _starsPopupController.value;
    if (v < 0.5 || v >= 1.0) return const SizedBox.shrink();

    final flight = Curves.easeInOut.transform((v - 0.5) / 0.5);
    final starOpacity = (1.0 - flight).clamp(0.0, 1.0);

    return IgnorePointer(
      child: Stack(
        children: List.generate(stars, (i) {
          final delay = i * 0.1;
          final p = ((flight - delay) / (1.0 - delay)).clamp(0.0, 1.0);

          // Horizontal spread based on star index
          final xOffset = (i - (stars - 1) / 2) * 0.15;
          final startAlign = Alignment(xOffset, -0.05);
          const endAlign = Alignment(0.0, 0.35);

          final currentAlign = Alignment(
            startAlign.x + (endAlign.x - startAlign.x) * p,
            startAlign.y + (endAlign.y - startAlign.y) * p,
          );

          final size = 48.0 - 16.0 * p;

          return Align(
            alignment: currentAlign,
            child: Opacity(
              opacity: starOpacity,
              child: Icon(
                Icons.star,
                color: AppTheme.starColor,
                size: size,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _XpProgressBar extends StatelessWidget {
  final double progress;
  final int level;
  final int currentXp;
  final int xpNeeded;
  final bool isDark;
  final Color textColor;

  const _XpProgressBar({
    required this.progress,
    required this.level,
    required this.currentXp,
    required this.xpNeeded,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor =
        isDark ? const Color(0xFFFFC947) : const Color(0xFF6C63FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            'Lv.$level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$currentXp/$xpNeeded',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF8899AA) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color textColor;
  final bool isDark;

  const _StatBox({
    required this.value,
    required this.label,
    required this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFFFC947) : textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF8899AA) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
