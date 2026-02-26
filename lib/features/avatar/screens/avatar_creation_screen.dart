import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:magic_learning/features/avatar/painters/character_painter.dart';
import 'package:magic_learning/features/avatar/providers/avatar_provider.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_character.dart';
import 'package:magic_learning/models/avatar.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class AvatarCreationScreen extends ConsumerStatefulWidget {
  const AvatarCreationScreen({super.key});

  @override
  ConsumerState<AvatarCreationScreen> createState() =>
      _AvatarCreationScreenState();
}

class _AvatarCreationScreenState extends ConsumerState<AvatarCreationScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  late PageController _pageController;
  int _selectedCharacter = 0;

  static const _characterNames = [
    'Czarodziej',
    'Wróżka',
    'Syrena',
    'Superbohater',
    'Kosmita',
    'Robot',
  ];

  static const _characterDescriptions = [
    'Mistrz zaklęć i magicznych sztuczek',
    'Posiadaczka skrzydeł i czarodziejskiej różdżki',
    'Władca mórz i oceanów',
    'Obrońca dobra i sprawiedliwości',
    'Podróżnik z odległej galaktyki',
    'Przyjaciel pełen technologii',
  ];

  static const _backgroundGradients = [
    [Color(0xFF1A0533), Color(0xFF4A1A7A)], // mage - deep purple
    [Color(0xFF2D0A3E), Color(0xFF7B2D8E)], // fairy - magenta
    [Color(0xFF0A1628), Color(0xFF0D3B66)], // merperson - deep ocean
    [Color(0xFF1A0A0A), Color(0xFF6B1010)], // superhero - dark red
    [Color(0xFF0A1A0A), Color(0xFF1B4332)], // alien - dark green
    [Color(0xFF0F1318), Color(0xFF2C3E50)], // robot - dark steel
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _selectedCharacter = index);
  }

  void _goToPrevious() {
    if (_selectedCharacter > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_selectedCharacter < AvatarCharacter.characterCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = _backgroundGradients[_selectedCharacter % _backgroundGradients.length];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Title
              Text(
                l10n.createAvatar,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.chooseCharacter,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              // Character carousel with arrows
              Expanded(
                flex: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // PageView of full-body characters
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: AvatarCharacter.characterCount,
                      itemBuilder: (context, index) {
                        return _CharacterPage(
                          characterIndex: index,
                          name: _characterNames[index],
                          description: _characterDescriptions[index],
                        );
                      },
                    ),
                    // Left arrow
                    if (_selectedCharacter > 0)
                      Positioned(
                        left: 8,
                        child: _ArrowButton(
                          icon: Icons.chevron_left,
                          onTap: _goToPrevious,
                        ),
                      ),
                    // Right arrow
                    if (_selectedCharacter < AvatarCharacter.characterCount - 1)
                      Positioned(
                        right: 8,
                        child: _ArrowButton(
                          icon: Icons.chevron_right,
                          onTap: _goToNext,
                        ),
                      ),
                  ],
                ),
              ),
              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  AvatarCharacter.characterCount,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: i == _selectedCharacter ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i == _selectedCharacter
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Name input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.namePlaceholder,
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    counterStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  maxLength: 20,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 12),
              // Start button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nameController.text.trim().isEmpty
                        ? null
                        : _createAvatar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _backgroundGradients[_selectedCharacter][1],
                      disabledBackgroundColor: Colors.white.withValues(alpha: 0.15),
                      disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.start,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAvatar() async {
    final avatar = Avatar(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      characterIndex: _selectedCharacter,
    );
    await ref.read(avatarProvider.notifier).createAvatar(avatar);
    if (mounted) {
      context.go('/hub');
    }
  }
}

class _CharacterPage extends StatelessWidget {
  final int characterIndex;
  final String name;
  final String description;

  const _CharacterPage({
    required this.characterIndex,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Full-body character
        SizedBox(
          width: 180,
          height: 320,
          child: CustomPaint(
            painter: CharacterPainter(characterIndex: characterIndex),
          ),
        ),
        const SizedBox(height: 16),
        // Character type name
        Text(
          name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        // Description
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
