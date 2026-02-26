import 'package:flutter/material.dart';
import 'package:magic_learning/features/minigames/clock/clock_face_widget.dart';
import 'package:magic_learning/features/minigames/clock/clock_game.dart';

class ClockQuestionDisplay extends StatelessWidget {
  final ClockQuestion question;

  const ClockQuestionDisplay({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF222640),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Clock face(s)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClockFaceWidget(
                hour12: question.clockHours[0],
                size: question.clockHours.length > 1 ? 95 : 110,
              ),
              if (question.clockHours.length > 1) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '\u2192',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFD740),
                    ),
                  ),
                ),
                ClockFaceWidget(
                  hour12: question.clockHours[1],
                  size: 95,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Question text
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
