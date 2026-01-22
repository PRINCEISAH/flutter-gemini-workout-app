import 'package:flutter/material.dart';

/// Represents a workout plan with sections for different exercise phases
class WorkoutPlan {
  final String? warmUp;
  final String? mainWorkout;
  final String? coolDown;
  final String? nutritionTips;

  WorkoutPlan({
    this.warmUp,
    this.mainWorkout,
    this.coolDown,
    this.nutritionTips,
  });

  /// Convert to JSON-like map for easier manipulation
  Map<String, dynamic> toMap() => {
        'warmUp': warmUp,
        'mainWorkout': mainWorkout,
        'coolDown': coolDown,
        'nutritionTips': nutritionTips,
      };

  /// Get all non-null sections
  Map<String, dynamic> getSections() {
    final sections = <String, dynamic>{};
    if (warmUp != null) sections['warmUp'] = warmUp;
    if (mainWorkout != null) sections['mainWorkout'] = mainWorkout;
    if (coolDown != null) sections['coolDown'] = coolDown;
    if (nutritionTips != null) sections['nutritionTips'] = nutritionTips;
    return sections;
  }
}

/// Represents the current state of workout execution
class WorkoutExecutionState {
  final int currentSectionIndex;
  final bool isStarted;
  final int countdownSeconds;
  final bool isCountingDown;

  WorkoutExecutionState({
    this.currentSectionIndex = 0,
    this.isStarted = false,
    this.countdownSeconds = 0,
    this.isCountingDown = false,
  });

  /// Create a copy with modified fields
  WorkoutExecutionState copyWith({
    int? currentSectionIndex,
    bool? isStarted,
    int? countdownSeconds,
    bool? isCountingDown,
  }) =>
      WorkoutExecutionState(
        currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
        isStarted: isStarted ?? this.isStarted,
        countdownSeconds: countdownSeconds ?? this.countdownSeconds,
        isCountingDown: isCountingDown ?? this.isCountingDown,
      );

  /// Reset to initial state
  WorkoutExecutionState reset() => WorkoutExecutionState();
}

/// Represents a section within a workout
class WorkoutSection {
  final String title;
  final List<String> items;
  final Color color;
  final IconData icon;

  WorkoutSection({
    required this.title,
    required this.items,
    required this.color,
    required this.icon,
  });
}
