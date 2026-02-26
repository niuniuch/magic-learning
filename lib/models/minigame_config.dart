import 'package:flutter/material.dart';
import 'package:magic_learning/models/buildable_model.dart';

enum MiniGameType {
  addition,
  subtraction,
  multiplication,
  clockReading,
}

class MiniGameConfig {
  final MiniGameType type;
  final String id;
  final String titleKey;
  final IconData icon;
  final Color color;
  final List<GameMode> modes;
  final BuildableType? buildableType;

  const MiniGameConfig({
    required this.type,
    required this.id,
    required this.titleKey,
    required this.icon,
    required this.color,
    required this.modes,
    this.buildableType,
  });
}

class GameMode {
  final String id;
  final String titleKey;
  final int minValue;
  final int maxValue;
  final int? multiplier; // For multiplication mode

  const GameMode({
    required this.id,
    required this.titleKey,
    required this.minValue,
    required this.maxValue,
    this.multiplier,
  });
}

class MiniGameConfigs {
  MiniGameConfigs._();

  static const List<MiniGameConfig> all = [
    MiniGameConfig(
      type: MiniGameType.addition,
      id: 'addition',
      titleKey: 'addition',
      icon: Icons.add_circle,
      color: Color(0xFF4CAF50),
      buildableType: BuildableType.rocket,
      modes: [
        GameMode(id: 'add_10', titleKey: 'additionUpTo10', minValue: 1, maxValue: 10),
        GameMode(id: 'add_20', titleKey: 'additionUpTo20', minValue: 1, maxValue: 20),
        GameMode(id: 'add_100', titleKey: 'additionUpTo100', minValue: 1, maxValue: 100),
      ],
    ),
    MiniGameConfig(
      type: MiniGameType.subtraction,
      id: 'subtraction',
      titleKey: 'subtraction',
      icon: Icons.remove_circle,
      color: Color(0xFFFF9800),
      buildableType: BuildableType.rocket,
      modes: [
        GameMode(id: 'sub_10', titleKey: 'subtractionUpTo10', minValue: 1, maxValue: 10),
        GameMode(id: 'sub_20', titleKey: 'subtractionUpTo20', minValue: 1, maxValue: 20),
        GameMode(id: 'sub_100', titleKey: 'subtractionUpTo100', minValue: 1, maxValue: 100),
      ],
    ),
    MiniGameConfig(
      type: MiniGameType.multiplication,
      id: 'multiplication',
      titleKey: 'multiplication',
      icon: Icons.close,
      color: Color(0xFF2196F3),
      buildableType: BuildableType.rocket,
      modes: [
        GameMode(id: 'mul_2', titleKey: 'multiplicationBy2', minValue: 1, maxValue: 10, multiplier: 2),
        GameMode(id: 'mul_3', titleKey: 'multiplicationBy3', minValue: 1, maxValue: 10, multiplier: 3),
        GameMode(id: 'mul_4', titleKey: 'multiplicationBy4', minValue: 1, maxValue: 10, multiplier: 4),
        GameMode(id: 'mul_5', titleKey: 'multiplicationBy5', minValue: 1, maxValue: 10, multiplier: 5),
      ],
    ),
    MiniGameConfig(
      type: MiniGameType.clockReading,
      id: 'clockReading',
      titleKey: 'clockReading',
      icon: Icons.access_time,
      color: Color(0xFFFF4D4D),
      buildableType: BuildableType.car,
      modes: [
        GameMode(id: 'clock_ampm', titleKey: 'clockAmPm', minValue: 0, maxValue: 23),
        GameMode(id: 'clock_elapsed', titleKey: 'clockElapsed', minValue: 1, maxValue: 8),
        GameMode(id: 'clock_future', titleKey: 'clockFuture', minValue: 1, maxValue: 8),
      ],
    ),
  ];
}
