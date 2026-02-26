import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/l10n/app_localizations.dart';

class ModeSelectionScreen extends StatefulWidget {
  final MiniGameConfig config;

  const ModeSelectionScreen({super.key, required this.config});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  late String _selectedModeId;

  @override
  void initState() {
    super.initState();
    _selectedModeId = widget.config.modes.first.id;
  }

  String _getModeTitle(AppLocalizations l10n, String titleKey) {
    switch (titleKey) {
      case 'additionUpTo10':
        return l10n.additionUpTo10;
      case 'additionUpTo20':
        return l10n.additionUpTo20;
      case 'additionUpTo100':
        return l10n.additionUpTo100;
      case 'subtractionUpTo10':
        return l10n.subtractionUpTo10;
      case 'subtractionUpTo20':
        return l10n.subtractionUpTo20;
      case 'subtractionUpTo100':
        return l10n.subtractionUpTo100;
      case 'multiplicationBy2':
        return l10n.multiplicationBy2;
      case 'multiplicationBy3':
        return l10n.multiplicationBy3;
      case 'multiplicationBy4':
        return l10n.multiplicationBy4;
      case 'multiplicationBy5':
        return l10n.multiplicationBy5;
      case 'clockAmPm':
        return 'Przed/po południu';
      case 'clockElapsed':
        return 'Ile czasu minęło?';
      case 'clockFuture':
        return 'Która będzie?';
      default:
        return titleKey;
    }
  }

  String _getGameTitle(AppLocalizations l10n) {
    switch (widget.config.id) {
      case 'addition':
        return l10n.addition;
      case 'subtraction':
        return l10n.subtraction;
      case 'multiplication':
        return l10n.multiplication;
      case 'clockReading':
        return 'Zegar';
      default:
        return widget.config.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedMode = widget.config.modes.firstWhere((m) => m.id == _selectedModeId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getGameTitle(l10n)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectMode,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.config.modes.length,
                  itemBuilder: (context, index) {
                    final mode = widget.config.modes[index];
                    final isSelected = mode.id == _selectedModeId;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ModeButton(
                        title: _getModeTitle(l10n, mode.titleKey),
                        color: widget.config.color,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedModeId = mode.id),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      '/game/${widget.config.id}/pick-buildable',
                      extra: {
                        'config': widget.config,
                        'mode': selectedMode,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.config.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'DALEJ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? color
                  : color.withValues(alpha: 0.2),
              width: isSelected ? 3 : 2,
            ),
          ),
          child: Row(
            children: [
              if (isSelected)
                Icon(Icons.check_circle, color: color, size: 24)
              else
                Icon(Icons.radio_button_unchecked, color: color.withValues(alpha: 0.4), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? color
                        : color.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
