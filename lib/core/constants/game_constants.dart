class GameConstants {
  GameConstants._();

  // XP & Leveling
  static const int starsPerCorrectAnswer = 1;
  static const int questionsPerRound = 10;
  static const int rocketPieces = 10;

  static int xpForLevel(int level) => 15;

  // Avatar
  static const int maxAvatarLevel = 25;

  // Upgrade tracks
  static const int upgradeInterval = 2;
  static const int firstUpgradeLevel = 3;

  /// Returns true for levels 3, 5, 7, 9, ..., 25
  static bool isUpgradeLevel(int level) {
    return level >= firstUpgradeLevel &&
        level <= maxAvatarLevel &&
        (level - firstUpgradeLevel) % upgradeInterval == 0;
  }

  /// How many total upgrade points earned by reaching this level.
  static int upgradePointsEarnedAtLevel(int level) {
    if (level < firstUpgradeLevel) return 0;
    return ((level - firstUpgradeLevel) ~/ upgradeInterval) + 1;
  }

  // Parental gate
  static const int parentalGateMaxMultiplier = 12;
  static const int parentalGateMinMultiplier = 6;

  // Streak & scoring
  static const int streakBonusThreshold = 3;
  static const int streakBonusMultiplier = 2;

  // Star thresholds (percentage-based)
  static const double threeStarThreshold = 0.85;
  static const double twoStarThreshold = 0.65;
  static const double oneStarThreshold = 0.45;
}
