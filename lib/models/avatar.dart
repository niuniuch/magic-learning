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

  const Avatar({
    required this.id,
    required this.name,
    required this.characterIndex,
    this.level = 0,
    this.xp = 0,
    this.unlockedUpgrades = const [],
    this.activeHat,
    this.colorIndex = 0,
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
      };

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json['id'] as String,
        name: json['name'] as String,
        characterIndex: json['characterIndex'] as int,
        level: json['level'] as int? ?? 0,
        xp: json['xp'] as int? ?? 0,
        unlockedUpgrades:
            (json['unlockedUpgrades'] as List<dynamic>?)?.cast<String>() ??
                const [],
        activeHat: json['activeHat'] as String?,
        colorIndex: json['colorIndex'] as int? ?? 0,
      );

  String encode() => jsonEncode(toJson());
  static Avatar decode(String source) =>
      Avatar.fromJson(jsonDecode(source) as Map<String, dynamic>);

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
      ];
}
