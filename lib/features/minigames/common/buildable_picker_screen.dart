import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_learning/models/buildable_model.dart';
import 'package:magic_learning/models/minigame_config.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/painters/rocket_painter.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/painters/car_painter.dart';

class BuildablePickerScreen extends StatefulWidget {
  final MiniGameConfig config;
  final GameMode mode;

  const BuildablePickerScreen({
    super.key,
    required this.config,
    required this.mode,
  });

  @override
  State<BuildablePickerScreen> createState() => _BuildablePickerScreenState();
}

class _BuildablePickerScreenState extends State<BuildablePickerScreen> {
  late List<BuildableModel> _models;
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    final type = widget.config.buildableType ?? BuildableType.rocket;
    _models = BuildableModel.getByType(type);
    _selectedId = _models.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final isRocket = (widget.config.buildableType ?? BuildableType.rocket) == BuildableType.rocket;
    final goldColor = const Color(0xFFFFC947);

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: isRocket ? const Color(0xFF0B0E1A) : const Color(0xFF1B1E2E),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  isRocket ? 'Wybierz swoją rakietę!' : 'Wybierz swoją wyścigówkę!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFFFFC947), Color(0xFFFF6B6B), Color(0xFF845EF7)],
                      ).createShader(const Rect.fromLTWH(0, 0, 300, 40)),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Każda jest wyjątkowa — którą chcesz zbudować?',
                  style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: _models.length,
                    itemBuilder: (context, index) {
                      final model = _models[index];
                      final selected = model.id == _selectedId;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedId = model.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF1B2550) : const Color(0xFF131836),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected ? goldColor : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: selected
                                ? [BoxShadow(color: goldColor.withValues(alpha: 0.15), blurRadius: 20)]
                                : [],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 70,
                                height: isRocket ? 110 : 100,
                                child: CustomPaint(
                                  painter: isRocket
                                      ? RocketPainter(builtParts: 10, colorScheme: model.colorScheme)
                                      : CarPainter(builtParts: 10, colorScheme: model.colorScheme),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                model.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFFDDDDEE),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                model.description,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => context.pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldColor,
                            foregroundColor: const Color(0xFF0B0E1A),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          child: const Text('Wróć', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
                            context.push(
                              '/game/${widget.config.id}/build-play',
                              extra: {
                                'config': widget.config,
                                'mode': widget.mode,
                                'buildableId': _selectedId,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94560),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          child: const Text('BUDUJEMY!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
