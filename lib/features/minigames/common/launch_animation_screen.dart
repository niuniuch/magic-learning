import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/painters/car_side_painter.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/painters/rocket_painter.dart';
import 'package:magic_learning/models/buildable_model.dart';
import 'package:magic_learning/models/minigame_result.dart';

class LaunchAnimationScreen extends StatefulWidget {
  final MiniGameResult result;
  final BuildableModel buildableModel;

  const LaunchAnimationScreen({
    super.key,
    required this.result,
    required this.buildableModel,
  });

  @override
  State<LaunchAnimationScreen> createState() => _LaunchAnimationScreenState();
}

class _LaunchAnimationScreenState extends State<LaunchAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _countdownController;
  late AnimationController _launchController;
  late Animation<double> _launchOffset;
  late Animation<double> _launchFade;
  late AnimationController _exhaustController;

  int _countdownValue = 3;
  bool _showStart = false;
  bool _launched = false;

  @override
  void initState() {
    super.initState();

    _countdownController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _launchController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _exhaustController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat(reverse: true);

    final isRocket = widget.buildableModel.type == BuildableType.rocket;
    if (isRocket) {
      _launchOffset = Tween<double>(begin: 0, end: -800).animate(
        CurvedAnimation(parent: _launchController, curve: Curves.easeInCubic),
      );
    } else {
      // Car: slight reverse at start, then drive right off screen
      _launchOffset = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: -10),
          weight: 15,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: -10, end: 800)
              .chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 85,
        ),
      ]).animate(_launchController);
    }
    _launchFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _launchController,
        curve: const Interval(0.5, 1.0),
      ),
    );

    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _countdownValue = i);
      _countdownController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    if (!mounted) return;
    setState(() => _showStart = true);
    _countdownController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _launched = true);
    _launchController.forward();
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;
    _goToResults();
  }

  void _goToResults() {
    context.go('/game/result', extra: widget.result);
  }

  @override
  void dispose() {
    _countdownController.dispose();
    _launchController.dispose();
    _exhaustController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRocket = widget.buildableModel.type == BuildableType.rocket;
    final bgColor = isRocket ? const Color(0xFF0B0E1A) : const Color(0xFF1B1E2E);

    return Theme(
      data: ThemeData.dark().copyWith(scaffoldBackgroundColor: bgColor),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Countdown / START text
              AnimatedBuilder(
                animation: _countdownController,
                builder: (context, child) {
                  final scale = 1.0 + _countdownController.value * 0.3;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Text(
                  _showStart
                      ? (isRocket ? '\u{1F680} START! \u{1F680}' : '\u{1F3C1} START! \u{1F3C1}')
                      : '$_countdownValue...',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFFC947),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Buildable model with launch animation
              AnimatedBuilder(
                animation: _launchController,
                builder: (context, child) {
                  final offset = isRocket
                      ? Offset(0, _launchOffset.value)
                      : Offset(_launchOffset.value, 0);
                  return Transform.translate(
                    offset: offset,
                    child: Opacity(
                      opacity: _launched ? _launchFade.value : 1.0,
                      child: child,
                    ),
                  );
                },
                child: isRocket ? _buildRocket() : _buildCar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRocket() {
    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 320,
          child: CustomPaint(
            painter: RocketPainter(
              builtParts: 10,
              colorScheme: widget.buildableModel.colorScheme,
            ),
          ),
        ),
        // Rocket flame below
        if (_launched)
          Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFC947),
                  const Color(0xFFFF6B00).withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Exhaust behind the car (to the left)
        if (_launched)
          AnimatedBuilder(
            animation: _exhaustController,
            builder: (context, _) {
              final w = 35 + _exhaustController.value * 15;
              final opacity = 0.7 + _exhaustController.value * 0.3;
              return Container(
                width: w,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment.centerRight,
                    colors: [
                      Color(0x99FF8C00),
                      Color(0x4DFF4D4D),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundDecoration: BoxDecoration(
                  color: Colors.transparent.withValues(alpha: 1.0 - opacity),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        // Side-view car
        SizedBox(
          width: 180,
          height: 90,
          child: CustomPaint(
            painter: CarSidePainter(
              colorScheme: widget.buildableModel.colorScheme,
            ),
          ),
        ),
      ],
    );
  }
}
