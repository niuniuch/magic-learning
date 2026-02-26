import 'package:flutter/material.dart';

class StatsBar extends StatelessWidget {
  final int score;
  final int streak;
  final int parts;
  final int totalParts;
  final int elapsedSeconds;

  const StatsBar({
    super.key,
    required this.score,
    required this.streak,
    required this.parts,
    required this.totalParts,
    required this.elapsedSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatPill(icon: '\u2B50', value: '$score'),
        const SizedBox(width: 6),
        _StatPill(icon: '\u{1F525}', value: '$streak'),
        const SizedBox(width: 6),
        _StatPill(icon: '\u{1F527}', value: '$parts/$totalParts'),
        const SizedBox(width: 6),
        _StatPill(icon: '\u23F1', value: '${elapsedSeconds}s'),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String icon;
  final String value;

  const _StatPill({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF131836),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
