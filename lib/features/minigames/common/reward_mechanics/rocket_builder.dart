import 'package:flutter/material.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/base_reward.dart';

class RocketBuilder extends BaseRewardMechanic {
  const RocketBuilder({
    super.key,
    required super.totalPieces,
    required super.currentPieces,
    required super.isComplete,
  });

  @override
  State<RocketBuilder> createState() => _RocketBuilderState();
}

class _RocketBuilderState extends State<RocketBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _launchController;
  late Animation<double> _launchAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _launchController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _launchAnimation = Tween<double>(begin: 0, end: -300).animate(
      CurvedAnimation(parent: _launchController, curve: Curves.easeInCubic),
    );
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _launchController,
        curve: const Interval(0.5, 1.0),
      ),
    );
  }

  @override
  void didUpdateWidget(RocketBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isComplete && !oldWidget.isComplete) {
      _launchController.forward();
    }
  }

  @override
  void dispose() {
    _launchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.totalPieces > 0
        ? widget.currentPieces / widget.totalPieces
        : 0.0;

    return SizedBox(
      height: 200,
      child: AnimatedBuilder(
        animation: _launchController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _launchAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rocket visualization
            Stack(
              alignment: Alignment.center,
              children: [
                // Background glow
                if (progress > 0)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: progress * 0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                // Rocket emoji with size animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 40, end: 40 + (progress * 40)),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, size, child) {
                    return Text(
                      '\u{1F680}',
                      style: TextStyle(fontSize: size),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value.clamp(0.0, 1.0),
                      minHeight: 16,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(Colors.orange, Colors.green, value)!,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.currentPieces} / ${widget.totalPieces}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Flame effect when launching
            if (widget.isComplete)
              const Text(
                '\u{1F525}\u{1F525}\u{1F525}',
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}
