import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Utility for managing icons and colors for workout sections
class WorkoutSectionUtils {
  // Private constructor
  WorkoutSectionUtils._();

  /// Section color mappings
  static const Map<String, Color> _sectionColors = {
    'warmUp': AppColors.secondary,
    'mainWorkout': AppColors.accent,
    'coolDown': AppColors.success,
    'nutritionTips': AppColors.warning,
  };

  /// Section icon mappings
  static const Map<String, IconData> _sectionIcons = {
    'warmUp': Icons.local_fire_department,
    'mainWorkout': Icons.fitness_center,
    'coolDown': Icons.spa,
    'nutritionTips': Icons.restaurant,
  };

  /// Get color for a section
  static Color getColor(String sectionKey) =>
      _sectionColors[sectionKey] ?? AppColors.accent;

  /// Get icon for a section
  static IconData getIcon(String sectionKey) =>
      _sectionIcons[sectionKey] ?? Icons.fitness_center;

  /// Get display title for a section
  static String getDisplayTitle(String sectionKey) {
    const titles = {
      'warmUp': 'Warm Up',
      'mainWorkout': 'Main Workout',
      'coolDown': 'Cool Down',
      'nutritionTips': 'Nutrition Tips',
    };
    return titles[sectionKey] ?? sectionKey;
  }

  /// Get icon for fitness goal
  static IconData getGoalIcon(String goal) {
    const goalIcons = {
      'Lose Weight': Icons.trending_down,
      'Build Muscle': Icons.fitness_center,
      'Get Stronger': Icons.sports_martial_arts,
      'Improve Endurance': Icons.favorite,
      'Increase Flexibility': Icons.accessibility,
    };
    return goalIcons[goal] ?? Icons.fitness_center;
  }
}
