/// Fitness app constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Fitness goals available to users
  static const List<String> fitnessGoals = [
    'Lose Weight',
    'Build Muscle',
    'Get Stronger',
    'Improve Endurance',
    'Increase Flexibility'
  ];

  /// Experience levels for workout personalization
  static const List<String> experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  /// Available workout durations
  static const List<String> durations = [
    '20 mins',
    '30 mins',
    '45 mins',
    '60 mins'
  ];

  /// Countdown duration before workout starts (in seconds)
  static const int countdownDuration = 3;

  /// Animation duration for fade transitions (in milliseconds)
  static const int fadeDuration = 800;

  /// Animation duration for slide transitions (in milliseconds)
  static const int slideDuration = 600;

  // Spacing constants
  static const double screenPadding = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double cardBorderRadius = 20.0;
  static const double cardPadding = 20.0;
  static const double largeIconSize = 48.0;
  static const double smallCardHeight = 120.0;

  // Home Screen string constants
  static const String greeting = 'Ready to Train?';
  static const String progressTitle = 'Weekly Progress';
  static const String caloriesTitle = 'Calories';
  static const String workoutsTitle = 'Workouts';
  static const String streakTitle = 'Streak';
  static const String generatePlanTitle = 'Generate Workout';
  static const String generatePlanDescription = 'AI-powered personalized plans';
  static const String tapToStart = 'Tap to start';
  static const String quickActionsTitle = 'Quick Actions';
  static const String timerLabel = 'Timer';
  static const String statsLabel = 'Stats';
  static const String healthLabel = 'Health';
}
