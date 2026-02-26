import 'package:flutter/material.dart';
import 'package:magic_learning/models/buildable_model.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/painters/rocket_painter.dart';
import 'package:magic_learning/features/minigames/common/reward_mechanics/painters/car_painter.dart';

class BuildableWidget extends StatefulWidget {
  final BuildableModel model;
  final int builtParts;
  final int totalParts;
  final bool justAdded;
  final bool justRemoved;

  const BuildableWidget({
    super.key,
    required this.model,
    required this.builtParts,
    this.totalParts = 10,
    this.justAdded = false,
    this.justRemoved = false,
  });

  @override
  State<BuildableWidget> createState() => _BuildableWidgetState();
}

class _BuildableWidgetState extends State<BuildableWidget>
    with TickerProviderStateMixin {
  late AnimationController _buildController;
  late AnimationController _shakeController;
  late Animation<double> _buildScale;
  late Animation<double> _shakeOffset;

  @override
  void initState() {
    super.initState();
    _buildController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _buildScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _buildController, curve: Curves.easeOut));

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -4), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -4, end: 4), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 4, end: -3), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -3, end: 3), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 3, end: 0), weight: 20),
    ]).animate(_shakeController);
  }

  @override
  void didUpdateWidget(BuildableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.justAdded && !oldWidget.justAdded) {
      _buildController.forward(from: 0);
    }
    if (widget.justRemoved && !oldWidget.justRemoved) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _buildController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRocket = widget.model.type == BuildableType.rocket;
    final goldColor = const Color(0xFFFFC947);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF131836),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.model.name,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: goldColor,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: Listenable.merge([_buildController, _shakeController]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeOffset.value, 0),
                child: Transform.scale(
                  scale: _buildScale.value,
                  child: child,
                ),
              );
            },
            child: SizedBox(
              width: isRocket ? 95 : 95,
              height: isRocket ? 220 : 200,
              child: CustomPaint(
                painter: isRocket
                    ? RocketPainter(
                        builtParts: widget.builtParts,
                        colorScheme: widget.model.colorScheme,
                      )
                    : CarPainter(
                        builtParts: widget.builtParts,
                        colorScheme: widget.model.colorScheme,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.builtParts} / ${widget.totalParts} części',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Color(0xFF8899AA),
            ),
          ),
        ],
      ),
    );
  }
}
