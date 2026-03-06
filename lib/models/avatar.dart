import 'dart:convert';
import 'package:equatable/equatable.dart';

class Avatar extends Equatable {
  final String id;
  final String name;
  final int characterIndex;
  final int level;
  final int xp;
  final List<String> unlockedUpgrades;
  final String? activeHat;
  final int colorIndex;
  final Map<String, int> trackProgress; // trackId.name → stage (0-4)
  final int pendingUpgrades; // unspent upgrade points

  const Avatar({
    required this.id,
    required this.name,
    required this.characterIndex,
    this.level = 1,
    this.xp = 0,
    this.unlockedUpgrades = const [],
    this.activeHat,
    this.colorIndex = 0,
    this.trackProgress = const {},
    this.pendingUpgrades = 0,
  });

  Avatar copyWith({
    String? id,
    String? name,
    int? characterIndex,
    int? level,
    int? xp,
    List<String>? unlockedUpgrades,
    String? activeHat,
    int? colorIndex,
    Map<String, int>? trackProgress,
    int? pendingUpgrades,
  }) {
    return Avatar(
      id: id ?? this.id,
      name: name ?? this.name,
      characterIndex: characterIndex ?? this.characterIndex,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      unlockedUpgrades: unlockedUpgrades ?? this.unlockedUpgrades,
      activeHat: activeHat ?? this.activeHat,
      colorIndex: colorIndex ?? this.colorIndex,
      trackProgress: trackProgress ?? this.trackProgress,
      pendingUpgrades: pendingUpgrades ?? this.pendingUpgrades,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'characterIndex': characterIndex,
        'level': level,
        'xp': xp,
        'unlockedUpgrades': unlockedUpgrades,
        'activeHat': activeHat,
        'colorIndex': colorIndex,
        'trackProgress': trackProgress,
        'pendingUpgrades': pendingUpgrades,
      };

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json['id'] as String,
        name: json['name'] as String,
        characterIndex: json['characterIndex'] as int,
        level: (json['level'] as int? ?? 0).clamp(1, 99),
        xp: json['xp'] as int? ?? 0,
        unlockedUpgrades:
            (json['unlockedUpgrades'] as List<dynamic>?)?.cast<String>() ??
                const [],
        activeHat: json['activeHat'] as String?,
        colorIndex: json['colorIndex'] as int? ?? 0,
        trackProgress:
            (json['trackProgress'] as Map<String, dynamic>?)?.map(
                  (k, v) => MapEntry(k, v as int),
                ) ??
                const {},
        pendingUpgrades: json['pendingUpgrades'] as int? ?? 0,
      );

  String encode() => jsonEncode(toJson());
  static Avatar decode(String source) =>
      Avatar.fromJson(jsonDecode(source) as Map<String, dynamic>);

  /// Sum of all track stage values.
  int get totalTrackStages =>
      trackProgress.values.fold(0, (sum, v) => sum + v);

  @override
  List<Object?> get props => [
        id,
        name,
        characterIndex,
        level,
        xp,
        unlockedUpgrades,
        activeHat,
        colorIndex,
        trackProgress,
        pendingUpgrades,
      ];
}
