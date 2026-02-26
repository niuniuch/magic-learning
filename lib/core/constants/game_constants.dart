class GameConstants {
  GameConstants._();

  // XP & Leveling
  static const int starsPerCorrectAnswer = 1;
  static const int questionsPerRound = 10;
  static const int rocketPieces = 10;

  static int xpForLevel(int level) => 10 + (level * 5);

  // Avatar
  static const int maxAvatarLevel = 20;

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
