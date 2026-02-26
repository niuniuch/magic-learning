import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/core/audio/audio_manager.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _saved = false;
  int? _previousLevel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _saveResults());
  }

  Future<void> _saveResults() async {
    if (_saved) return;
    _saved = true;

    _previousLevel = ref.read(avatarProvider)?.level ?? 0;
    await ref.read(progressProvider.notifier).recordResult(widget.result);
    await ref.read(avatarProvider.notifier).addXp(widget.result.starsEarned);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avatar = ref.watch(avatarProvider);
    final leveledUp = _previousLevel != null &&
        avatar != null &&
        avatar.level > _previousLevel!;
    final accuracy = widget.result.accuracy;
    final audio = ref.read(audioManagerProvider);
    final hasBuildable = widget.result.buildableModelId != null;
    final buildable = hasBuildable
        ? BuildableModel.findById(widget.result.buildableModelId!)
        : null;

    if (leveledUp) {
      audio.playLevelUp();
    }

    // Use dark theme if we came from the new build flow
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
          child: SingleChildScrollView(
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
                // Title
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
                // Stars
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
                // Stats grid
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
                      // 2x2 stats grid
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
                      // Stars earned
                      const SizedBox(height: 12),
                      Text(
                        l10n.starsEarned(widget.result.starsEarned),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.starColor,
                        ),
                      ),
                    ],
                  ),
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
                // Level up notice
                if (leveledUp) ...[
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
                          '${l10n.levelUp} ${l10n.level} ${avatar.level}!',
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
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => context.go('/hub'),
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
                          onPressed: () {
                            if (leveledUp) {
                              context.go('/avatar/upgrade');
                            } else {
                              context.go('/hub');
                            }
                          },
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
                            leveledUp ? l10n.chooseUpgrade : 'ZAGRAJ JESZCZE RAZ',
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
        ),
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
