import 'package:flutter_gemini/flutter_gemini.dart';

/// Service for handling Gemini API interactions
class GeminiService {
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal();

  /// Generate a workout plan using Gemini API
  ///
  /// Returns the raw response text from Gemini
  Future<String?> generateWorkoutPlan({
    required String goal,
    required String experienceLevel,
    required String duration,
  }) async {
    final gemini = Gemini.instance;

    try {
      final response = await gemini.text(
        _buildPrompt(goal, experienceLevel, duration),
      );

      return response?.output;
    } catch (e) {
      throw Exception('Failed to generate workout plan: $e');
    }
  }

  /// Build the prompt for Gemini based on user selections
  String _buildPrompt(String goal, String experienceLevel, String duration) {
    return '''Generate a structured workout plan for someone with the goal of $goal and experience level: $experienceLevel 
with a workout duration of $duration. 
The plan should include: 1. Warm-up exercises 2. Main workout routine 3. Cool-down exercises 4. Nutrition tips. 
Format the response as a JSON object with these keys: warmUp, mainWorkout, coolDown, nutritionTips. 
For exercises and tips, use an array of strings. 
Example format: 
{
  "warmUp": ["Exercise 1", "Exercise 2"],
  "mainWorkout": ["Exercise 1", "Exercise 2"],
  "coolDown": ["Exercise 1", "Exercise 2"],
  "nutritionTips": ["Tip 1", "Tip 2"]
}''';
  }
}
