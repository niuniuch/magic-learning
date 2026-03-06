import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_full_body.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class AvatarUpgradeScreen extends ConsumerStatefulWidget {
  final int? previousLevel;
  final String? trackId;
  final String? stageName;
  final String? stageDescription;
  final String? trackName;

  const AvatarUpgradeScreen({
    super.key,
    this.previousLevel,
    this.trackId,
    this.stageName,
    this.stageDescription,
    this.trackName,
  });

  @override
  ConsumerState<AvatarUpgradeScreen> createState() =>
      _AvatarUpgradeScreenState();
}

class _AvatarUpgradeScreenState extends ConsumerState<AvatarUpgradeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  AnimationController? _shimmerController;
  AnimationController? _transformController;
  AnimationController? _burstController;

  bool _hasTransformation = false;
  bool _isTrackUpgrade = false;

  // 0=shimmer, 1=transform, 2=burst, 3=done
  int _phase = 3;

  @override
  void initState() {
    super.initState();

    _hasTransformation = widget.previousLevel != null || widget.trackId != null;
    _isTrackUpgrade = widget.trackId != null;

    // Pulse controller — always created, but started later if transforming
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    if (_hasTransformation) {
      _phase = 0;

      _shimmerController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      _transformController = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );
      _burstController = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );

      // Chain: shimmer → transform → burst → pulse+fade
      _shimmerController!.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _phase = 1);
          _transformController!.forward();
        }
      });
      _transformController!.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _phase = 2);
          _burstController!.forward();
        }
      });
      _burstController!.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _phase = 3);
          _pulseController.repeat(reverse: true);
          _fadeController.forward();
        }
      });

      _shimmerController!.forward();
    } else {
      _phase = 3;
      _pulseController.repeat(reverse: true);
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _shimmerController?.dispose();
    _transformController?.dispose();
    _burstController?.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = ref.watch(avatarProvider);
    final l10n = AppLocalizations.of(context)!;

    if (avatar == null) return const SizedBox.shrink();

    final charIdx = avatar.characterIndex % 6;
    final bgColors = _backgroundGradients[charIdx];

    // Track upgrade info
    final upgradeTitle = _isTrackUpgrade
        ? '${widget.trackName}: ${widget.stageName}'
        : '';
    final upgradeDesc = _isTrackUpgrade
        ? widget.stageDescription ?? ''
        : '';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
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
          child: Stack(
            children: [
              // Main content column
              Column(
                children: [
                  const SizedBox(height: 24),
                  // Celebration header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const Text(
                          '\u{2728}',
                          style: TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isTrackUpgrade
                              ? 'Nowe ulepszenie!'
                              : '${l10n.levelUp}!',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        if (_isTrackUpgrade && upgradeTitle.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              upgradeTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber.shade300,
                              ),
                            ),
                          ),
                        ],
                        if (!_isTrackUpgrade) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${l10n.level} ${avatar.level}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Character area with transformation
                  _buildCharacterArea(avatar.characterIndex, avatar.level,
                      avatar.trackProgress),
                  const Spacer(),
                  // Upgrade description
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: upgradeDesc.isNotEmpty
                        ? Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 32),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.amber.shade300
                                    .withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '\u{2728}',
                                  style: TextStyle(fontSize: 22),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    upgradeDesc,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  '\u{2728}',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  // Continue button — visible after animation completes
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.go('/hub'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: bgColors[1],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'DALEJ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
              // Spark burst overlay
              if (_burstController != null)
                IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _burstController!,
                    builder: (context, _) {
                      if (_phase < 2 || _burstController!.value == 0) {
                        return const SizedBox.shrink();
                      }
                      return Center(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: CustomPaint(
                            painter: _SparkBurstPainter(
                              progress: _burstController!.value,
                            ),
                          ),
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

  Widget _buildCharacterWidget(int characterIndex, int currentLevel, Map<String, int> trackProgress) {
    return AvatarFullBody(
      characterIndex: characterIndex,
      width: 200,
      height: 340,
      level: currentLevel,
      trackProgress: trackProgress,
    );
  }

  Widget _buildCharacterArea(
      int characterIndex, int currentLevel, Map<String, int> trackProgress) {
    if (!_hasTransformation) {
      return ScaleTransition(
        scale: _pulseAnimation,
        child: _buildCharacterWidget(characterIndex, currentLevel, trackProgress),
      );
    }

    // During shimmer phase: show character with golden shimmer overlay
    if (_phase == 0) {
      return AnimatedBuilder(
        animation: _shimmerController!,
        builder: (context, _) {
          final t = _shimmerController!.value;
          return SizedBox(
            width: 200,
            height: 340,
            child: Stack(
              children: [
                _buildCharacterWidget(characterIndex, currentLevel, trackProgress),
                CustomPaint(
                  size: const Size(200, 340),
                  painter: _ShimmerOverlayPainter(progress: t),
                ),
              ],
            ),
          );
        },
      );
    }

    // During transform phase: scale punch
    if (_phase == 1) {
      return AnimatedBuilder(
        animation: _transformController!,
        builder: (context, _) {
          final t = _transformController!.value;
          final scale = 1.0 +
              0.15 * Curves.elasticOut.transform(t.clamp(0.0, 1.0));

          return Transform.scale(
            scale: scale,
            child: _buildCharacterWidget(characterIndex, currentLevel, trackProgress),
          );
        },
      );
    }

    // Phase 2 (burst) and 3 (done): show character with pulse
    return ScaleTransition(
      scale: _pulseAnimation,
      child: _buildCharacterWidget(characterIndex, currentLevel, trackProgress),
    );
  }

  static const _backgroundGradients = [
    [Color(0xFF1A0533), Color(0xFF4A1A7A)], // mage
    [Color(0xFF2D0A3E), Color(0xFF7B2D8E)], // fairy
    [Color(0xFF0A1628), Color(0xFF0D3B66)], // merperson
    [Color(0xFF1A0A0A), Color(0xFF6B1010)], // superhero
    [Color(0xFF0A1A0A), Color(0xFF1B4332)], // alien
    [Color(0xFF0F1318), Color(0xFF2C3E50)], // robot
  ];
}

/// Golden radial shimmer overlay that intensifies over the animation.
class _ShimmerOverlayPainter extends CustomPainter {
  final double progress;

  _ShimmerOverlayPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.height * 0.5;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD700).withValues(alpha: progress * 0.5),
          const Color(0xFFFFD700).withValues(alpha: progress * 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_ShimmerOverlayPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// 25 particles radiating outward from center in gold/amber/white.
class _SparkBurstPainter extends CustomPainter {
  final double progress;
  static final _random = Random(42);
  static final _particles = List.generate(25, (_) => _Particle(
    angle: _random.nextDouble() * 2 * pi,
    speed: 0.5 + _random.nextDouble() * 0.5,
    size: 2.0 + _random.nextDouble() * 4.0,
    colorIndex: _random.nextInt(3),
  ));

  static const _colors = [
    Color(0xFFFFD700), // gold
    Color(0xFFFFBF00), // amber
    Color(0xFFFFFFFF), // white
  ];

  _SparkBurstPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxTravel = size.width * 0.45;

    for (final p in _particles) {
      final dist = maxTravel * progress * p.speed;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final particleSize = p.size * (1.0 - progress * 0.5);

      final pos = center + Offset(
        cos(p.angle) * dist,
        sin(p.angle) * dist,
      );

      final paint = Paint()
        ..color = _colors[p.colorIndex].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(_SparkBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final int colorIndex;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.colorIndex,
  });
}
