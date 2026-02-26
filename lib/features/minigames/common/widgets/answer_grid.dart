import 'package:flutter/material.dart';

class AnswerGrid extends StatelessWidget {
  final List<String> choices;
  final String correctAnswer;
  final String? selectedAnswer;
  final ValueChanged<String> onSelect;

  const AnswerGrid({
    super.key,
    required this.choices,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: choices.map((choice) {
        Color bgColor;
        if (selectedAnswer == null) {
          bgColor = const Color(0xFF0F3460);
        } else if (choice == correctAnswer) {
          bgColor = const Color(0xFF2ECC71);
        } else if (choice == selectedAnswer) {
          bgColor = const Color(0xFFE74C3C);
        } else {
          bgColor = const Color(0xFF0F3460).withValues(alpha: 0.5);
        }

        return GestureDetector(
          onTap: selectedAnswer == null ? () => onSelect(choice) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedAnswer == null
                    ? Colors.transparent
                    : choice == correctAnswer
                        ? const Color(0xFF27AE60)
                        : choice == selectedAnswer
                            ? const Color(0xFFC0392B)
                            : Colors.transparent,
                width: 3,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              choice,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
}
