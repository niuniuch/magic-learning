import 'package:flutter/material.dart';

abstract class BaseRewardMechanic extends StatefulWidget {
  final int totalPieces;
  final int currentPieces;
  final bool isComplete;

  const BaseRewardMechanic({
    super.key,
    required this.totalPieces,
    required this.currentPieces,
    required this.isComplete,
  });
}
