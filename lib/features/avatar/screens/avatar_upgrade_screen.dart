import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/features/avatar/painters/character_painter.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class AvatarUpgradeScreen extends ConsumerStatefulWidget {
  const AvatarUpgradeScreen({super.key});

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

  static const _tierNames = [
    '', // T0 - shouldn't show
    'Uczeń',
    'Adept',
    'Mistrz',
    'Legenda',
  ];

  static const _tierDescriptions = {
    0: {
      // Mage tiers
      1: 'Iskry magii otaczają laskę',
      2: 'Gwiazdy zdobią szatę',
      3: 'Magiczne runy unoszą się wokół',
      4: 'Złota szata legendy!',
    },
    1: {
      1: 'Skrzydła migoczą blaskiem',
      2: 'Różdżka promieniuje aurą',
      3: 'Skrzydła płoną magią',
      4: 'Tęczowe skrzydła i motyle!',
    },
    2: {
      1: 'Bąbelki unoszą się z ogona',
      2: 'Łuski lśnią, trójząb świeci',
      3: 'Perły zdobią koronę',
      4: 'Królewska moc oceanu!',
    },
    3: {
      1: 'Emblemat gwiazdy świeci',
      2: 'Błyskawice z rękawic',
      3: 'Peleryna faluje energią',
      4: 'Złota moc superbohatera!',
    },
    4: {
      1: 'Antena promieniuje energią',
      2: 'Wizjer technologiczny aktywny',
      3: 'Tarcza energetyczna włączona',
      4: 'Zaawansowana technologia!',
    },
    5: {
      1: 'Diody na szyi świecą',
      2: 'Ekran jarzy się mocniej',
      3: 'Iskry między przegubami',
      4: 'Złote wykończenie aktywne!',
    },
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, ) {
    final avatar = ref.watch(avatarProvider);
    final l10n = AppLocalizations.of(context)!;

    if (avatar == null) return const SizedBox.shrink();

    final tier = avatar.level ~/ 5;
    final charIdx = avatar.characterIndex % 6;
    final tierName = tier > 0 && tier < _tierNames.length
        ? _tierNames[tier]
        : '';
    final tierDesc = _tierDescriptions[charIdx]?[tier] ?? '';

    final bgColors = _backgroundGradients[charIdx];

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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Level up celebration
                const Text(
                  '\u{1F389}',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.levelUp}!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                if (tierName.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    tierName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber.shade300,
                      letterSpacing: 2,
                    ),
                  ),
                ],
                const Spacer(),
                // Full-body character with pulse animation
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: SizedBox(
                    width: 200,
                    height: 340,
                    child: CustomPaint(
                      painter: CharacterPainter(
                        characterIndex: avatar.characterIndex,
                        level: avatar.level,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // New upgrade description
                if (tierDesc.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amber.shade300.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\u{2728}',
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            tierDesc,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '\u{2728}',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                // Continue button
                Padding(
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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
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
