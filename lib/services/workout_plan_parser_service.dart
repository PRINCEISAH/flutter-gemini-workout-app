import 'dart:convert';

/// Service for parsing and processing workout plan responses
class WorkoutPlanParserService {
  static final WorkoutPlanParserService _instance =
      WorkoutPlanParserService._internal();

  factory WorkoutPlanParserService() {
    return _instance;
  }

  WorkoutPlanParserService._internal();

  /// Parse workout plan from API response text
  ///
  /// Attempts to parse as JSON first, then falls back to text parsing
  Map<String, dynamic> parse(String text) {
    // Clean up markdown code blocks
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      // Normalize time ranges (e.g., "10-15" to "10-15")
      text = text.replaceAllMapped(
        RegExp(r':\s*(\d+)-(\d+)([^\d]|$)'),
        (match) => ': "${match.group(1)}-${match.group(2)}"${match.group(3)}',
      );

      final jsonResponse = jsonDecode(text) as Map<String, dynamic>;
      return _processJsonResponse(jsonResponse);
    } catch (e) {
      print('JSON parsing failed, falling back to text parsing: $e');
      return _parseAsText(text);
    }
  }

  /// Process and normalize JSON response
  Map<String, dynamic> _processJsonResponse(Map<String, dynamic> json) {
    final keys = ['warmUp', 'mainWorkout', 'coolDown', 'nutritionTips'];

    for (final key in keys) {
      if (json[key] is List) {
        json[key] =
            (json[key] as List).map((item) => _normalizeItem(item)).toList();
      }
    }

    return json;
  }

  /// Normalize individual items in the workout plan
  String _normalizeItem(dynamic item) {
    if (item is Map) {
      return item.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    }
    return item.toString();
  }

  /// Fallback text parsing when JSON parsing fails
  Map<String, dynamic> _parseAsText(String text) {
    final plan = <String, dynamic>{};
    var currentSection = '';
    var currentList = <String>[];

    for (final line in text.split('\n')) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      if (trimmedLine.endsWith(':')) {
        // Save previous section
        if (currentSection.isNotEmpty) {
          plan[currentSection] =
              currentList.isNotEmpty ? currentList : 'No details provided';
          currentList = [];
        }
        currentSection = trimmedLine.substring(0, trimmedLine.length - 1);
      } else if (trimmedLine.startsWith('•') || trimmedLine.startsWith('-')) {
        // Item in list
        currentList.add(trimmedLine.substring(1).trim());
      } else if (currentSection.isNotEmpty) {
        // Content line
        currentList.add(trimmedLine);
      }
    }

    // Save last section
    if (currentSection.isNotEmpty) {
      plan[currentSection] =
          currentList.isNotEmpty ? currentList : 'No details provided';
    }

    return plan;
  }
}
