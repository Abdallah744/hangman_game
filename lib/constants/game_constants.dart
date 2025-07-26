class GameConstants {
  // Game settings
  static const int maxAttempts = 6;
  static const int maxWordLength = 12;
  static const int minWordLength = 3;
  
  // Score multipliers
  static const int basePointsPerLetter = 10;
  static const int pointsPerRemainingAttempt = 5;
  static const int bonusPointsForPerfectGame = 50;
  
  // Difficulty levels
  static const Map<String, dynamic> difficultyLevels = {
    'easy': {
      'name': 'Easy',
      'minLength': 3,
      'maxLength': 5,
      'scoreMultiplier': 1.0,
    },
    'medium': {
      'name': 'Medium',
      'minLength': 6,
      'maxLength': 8,
      'scoreMultiplier': 1.5,
    },
    'hard': {
      'name': 'Hard',
      'minLength': 9,
      'maxLength': 12,
      'scoreMultiplier': 2.0,
    },
  };
  
  // Word categories
  static const Map<String, List<String>> wordCategories = {
    'technology': [
      'FLUTTER', 'DART', 'MOBILE', 'DEVELOPMENT', 'PROGRAMMING',
      'COMPUTER', 'KEYBOARD', 'MONITOR', 'SOFTWARE', 'NETWORK',
      'DATABASE', 'ALGORITHM', 'FUNCTION', 'VARIABLE', 'SYNTAX'
    ],
    'animals': [
      'ELEPHANT', 'GIRAFFE', 'KANGAROO', 'DOLPHIN', 'BUTTERFLY',
      'CROCODILE', 'PENGUIN', 'KOALA', 'OCTOPUS', 'CHAMELEON',
      'HIPPOPOTAMUS', 'RACCOON', 'PLATYPUS', 'ARMADILLO', 'PANGOLIN'
    ],
    'countries': [
      'CANADA', 'JAPAN', 'BRAZIL', 'GERMANY', 'AUSTRALIA',
      'MEXICO', 'ITALY', 'EGYPT', 'THAILAND', 'ARGENTINA',
      'INDONESIA', 'MOROCCO', 'VIETNAM', 'UKRAINE', 'PHILIPPINES'
    ],
    'sports': [
      'BASKETBALL', 'FOOTBALL', 'TENNIS', 'VOLLEYBALL', 'BASEBALL',
      'HOCKEY', 'CRICKET', 'BADMINTON', 'SWIMMING', 'GYMNASTICS',
      'WRESTLING', 'BOXING', 'FENCING', 'ARCHERY', 'KARATE'
    ],
  };
  
  // Audio assets
  static const Map<String, String> audioFiles = {
    'correct': 'assets/audio/correct.mp3',
    'wrong': 'assets/audio/wrong.mp3',
    'win': 'assets/audio/win.mp3',
    'lose': 'assets/audio/lose.mp3',
    'button': 'assets/audio/button.mp3',
  };
  
  // Animation durations
  static const Duration letterRevealDuration = Duration(milliseconds: 300);
  static const Duration hangmanPartRevealDuration = Duration(milliseconds: 500);
  static const Duration buttonPressDuration = Duration(milliseconds: 100);
  static const Duration gameOverAnimationDuration = Duration(seconds: 2);
}
