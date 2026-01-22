# Before & After Code Comparison

## 1. Color Management

### ❌ Before (Scattered & Repeated)
```dart
// In generate_workout_screen.dart
class _GenerateWorkoutPlanScreenState extends State<GenerateWorkoutPlanScreen>
    with TickerProviderStateMixin {
  // Colors - Fitness App Theme
  static const Color _primaryColor = Color(0xFF1A1A2E);
  static const Color _accentColor = Color(0xFFFF6B35);
  static const Color _secondaryColor = Color(0xFF004E89);
  static const Color _successColor = Color(0xFF1EBE73);
  static const Color _warningColor = Color(0xFFFFA500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,  // ❌ Uses local constant
      appBar: AppBar(
        backgroundColor: _primaryColor,  // ❌ Repeated
        title: const Text(
          'Generate Workout Plan',
          style: TextStyle(
            color: Colors.white,  // ❌ Hardcoded color
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      // ... more usage of _primaryColor, _accentColor, etc
    );
  }

  Widget _buildGenerateButton() {
    return GestureDetector(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_accentColor, _accentColor.withOpacity(0.8)],  // ❌ Repeated
          ),
        ),
      ),
    );
  }
}

// In home_screen.dart - Colors redefined again!
static const Color _primaryColor = Color(0xFF1A1A2E);  // ❌ Duplication
static const Color _accentColor = Color(0xFFFF6B35);   // ❌ Duplication
```

### ✅ After (Centralized & Consistent)
```dart
// constants/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF1A1A2E);
  static const Color accent = Color(0xFFFF6B35);
  static const Color secondary = Color(0xFF004E89);
  static const Color success = Color(0xFF1EBE73);
  static const Color warning = Color(0xFFFFA500);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Colors.white70;
}

// In generate_workout_screen.dart
import 'constants/app_colors.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.primary,  // ✅ Clear & centralized
    appBar: AppBar(
      backgroundColor: AppColors.primary,  // ✅ Same source
      title: const Text(
        'Generate Workout Plan',
        style: TextStyle(
          color: AppColors.textWhite,  // ✅ Semantic naming
          fontWeight: FontWeight.w800,
          fontSize: 22,
        ),
      ),
    ),
  );
}

Widget _buildGenerateButton() {
  return GestureDetector(
    child: AnimatedContainer(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)],
        ),
      ),
    ),
  );
}

// In home_screen.dart - Simply import and reuse!
import 'constants/app_colors.dart';
backgroundColor: AppColors.primary,  // ✅ Single source of truth
```

---

## 2. API Integration

### ❌ Before (Business Logic Mixed with UI)
```dart
// In generate_workout_screen.dart
class _GenerateWorkoutPlanScreenState extends State<GenerateWorkoutPlanScreen> {
  Future<void> _generateWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _workoutPlan = null;
      _rawResponse = null;
    });

    _fadeController.forward();

    final gemini = Gemini.instance;  // ❌ Direct API call in UI logic

    try {
      final response = await gemini.text(  // ❌ Tightly coupled to Gemini
          "Generate a structured workout plan for someone with the goal of $_selectedGoal and experience level: $_selectedExperience "
          "with a workout duration of $_selectedDuration. "
          // ... long prompt building here
      );

      if (response?.output != null) {
        setState(() {
          _rawResponse = response!.output;
          _workoutPlan = _parseWorkoutPlan(response.output!);  // ❌ Parsing also in UI
          _isLoading = false;
        });
      } else {
        throw Exception('No output from Gemini');
      }
    } catch (e) {
      print('Error generating workout plan: $e');
      setState(() {
        _isLoading = false;
        _workoutPlan = null;
        _rawResponse = 'Error: $e';
      });
    }
  }
}
// ❌ Cannot test API logic without testing UI
// ❌ Cannot reuse API logic in other screens
// ❌ Hard to switch to different API provider
```

### ✅ After (Separation of Concerns)
```dart
// services/gemini_service.dart
class GeminiService {
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() => _instance;

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

  String _buildPrompt(String goal, String experienceLevel, String duration) {
    return '''Generate a structured workout plan...''';
  }
}

// In generate_workout_screen.dart
class _GenerateWorkoutPlanScreenState extends State<GenerateWorkoutPlanScreen> {
  late final GeminiService _geminiService;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService();
  }

  Future<void> _generateWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _workoutPlan = null;
      _rawResponse = null;
    });

    _fadeController.forward();

    try {
      final response = await _geminiService.generateWorkoutPlan(
        goal: _selectedGoal!,
        experienceLevel: _selectedExperience!,
        duration: _selectedDuration!,
      );

      if (response != null) {
        setState(() {
          _rawResponse = response;
          _workoutPlan = _parserService.parse(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _workoutPlan = null;
        _rawResponse = 'Error: $e';
      });
    }
  }
}
// ✅ API service can be tested independently
// ✅ Service can be reused in other screens
// ✅ Easy to mock for testing
// ✅ Easy to switch API provider
```

---

## 3. Response Parsing

### ❌ Before (Large Method in Screen)
```dart
// In generate_workout_screen.dart
class _GenerateWorkoutPlanScreenState extends State {
  // ... other code ...

  Map<String, dynamic> _parseWorkoutPlan(String text) {
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      text = text.replaceAllMapped(
          RegExp(r':\s*(\d+)-(\d+)([^\d]|$)'),
          (match) =>
              ': "${match.group(1)}-${match.group(2)}"${match.group(3)}');

      Map<String, dynamic> jsonResponse = jsonDecode(text);
      return _processJsonResponse(jsonResponse);
    } catch (e) {
      print('Error parsing JSON: $e');
      return _parseWorkoutPlanText(text);
    }
  }

  Map<String, dynamic> _processJsonResponse(
      Map<String, dynamic> jsonResponse) {
    for (var key in ['warmUp', 'mainWorkout', 'coolDown', 'nutritionTips']) {
      if (jsonResponse[key] is List) {
        jsonResponse[key] = jsonResponse[key].map((item) {
          if (item is Map) {
            return item.entries.map((e) => "${e.key}: ${e.value}").join(', ');
          }
          return item.toString();
        }).toList();
      }
    }
    return jsonResponse;
  }

  Map<String, dynamic> _parseWorkoutPlanText(String text) {
    final Map<String, dynamic> plan = {};
    String currentSection = '';
    List<String> currentList = [];

    for (var line in text.split('\n')) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.endsWith(':')) {
        if (currentSection.isNotEmpty) {
          plan[currentSection] =
              currentList.isNotEmpty ? currentList : 'No details provided';
          currentList = [];
        }
        currentSection = line.substring(0, line.length - 1);
      } else {
        if (line.startsWith('•') || line.startsWith('-')) {
          currentList.add(line.substring(1).trim());
        } else {
          currentList.add(line);
        }
      }
    }

    if (currentSection.isNotEmpty) {
      plan[currentSection] =
          currentList.isNotEmpty ? currentList : 'No details provided';
    }

    return plan;
  }
}
// ❌ 100+ lines of parsing logic in screen class
// ❌ Cannot test parsing independently
// ❌ Mixing parsing logic with UI logic
// ❌ Hard to reuse parsing logic
```

### ✅ After (Dedicated Service)
```dart
// services/workout_plan_parser_service.dart
class WorkoutPlanParserService {
  static final WorkoutPlanParserService _instance =
      WorkoutPlanParserService._internal();

  factory WorkoutPlanParserService() => _instance;

  WorkoutPlanParserService._internal();

  /// Parse workout plan from API response text
  Map<String, dynamic> parse(String text) {
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      text = text.replaceAllMapped(
        RegExp(r':\s*(\d+)-(\d+)([^\d]|$)'),
        (match) => ': "${match.group(1)}-${match.group(2)}"${match.group(3)}',
      );

      final jsonResponse = jsonDecode(text) as Map<String, dynamic>;
      return _processJsonResponse(jsonResponse);
    } catch (e) {
      return _parseAsText(text);
    }
  }

  // ... helper methods ...
}

// In generate_workout_screen.dart
class _GenerateWorkoutPlanScreenState extends State {
  late final WorkoutPlanParserService _parserService;

  @override
  void initState() {
    super.initState();
    _parserService = WorkoutPlanParserService();
  }

  Future<void> _generateWorkoutPlan() async {
    // ...
    _workoutPlan = _parserService.parse(response);  // ✅ One line!
    // ...
  }
}
// ✅ Parsing logic separated from UI
// ✅ Can be tested independently
// ✅ Can be reused in other screens
// ✅ Screen class is cleaner
```

---

## 4. Utility Functions

### ❌ Before (Methods Scattered in Screen)
```dart
// In generate_workout_screen.dart
class _GenerateWorkoutPlanScreenState extends State {
  IconData _getGoalIcon(String goal) {
    final iconMap = {
      'Lose Weight': Icons.trending_down,
      'Build Muscle': Icons.fitness_center,
      'Get Stronger': Icons.sports_martial_arts,
      'Improve Endurance': Icons.favorite,
      'Increase Flexibility': Icons.accessibility,
    };
    return iconMap[goal] ?? Icons.fitness_center;
  }

  String _formatSectionTitle(String title) {
    final titleMap = {
      'warmUp': 'Warm Up',
      'mainWorkout': 'Main Workout',
      'coolDown': 'Cool Down',
      'nutritionTips': 'Nutrition Tips',
    };
    return titleMap[title] ?? title;
  }

  Widget _buildWorkoutSection(String title, dynamic content, {Color? color, bool isActive = false}) {
    final sectionColors = {
      'warmUp': _secondaryColor,
      'mainWorkout': _accentColor,
      'coolDown': _successColor,
      'nutritionTips': _warningColor,
    };

    final sectionIcons = {
      'warmUp': Icons.local_fire_department,
      'mainWorkout': Icons.fitness_center,
      'coolDown': Icons.spa,
      'nutritionTips': Icons.restaurant,
    };

    final sectionColor = color ?? (sectionColors[title] ?? _accentColor);
    final icon = sectionIcons[title] ?? Icons.fitness_center;
    final displayTitle = _formatSectionTitle(title);
    // ... rest of the widget
  }
}
// ❌ Multiple mappings scattered throughout
// ❌ Difficult to maintain consistency
// ❌ Hard to reuse in other screens
// ❌ Screen class has too many concerns
```

### ✅ After (Centralized Utilities)
```dart
// utils/workout_section_utils.dart
class WorkoutSectionUtils {
  static const Map<String, Color> _sectionColors = {
    'warmUp': AppColors.secondary,
    'mainWorkout': AppColors.accent,
    'coolDown': AppColors.success,
    'nutritionTips': AppColors.warning,
  };

  static const Map<String, IconData> _sectionIcons = {
    'warmUp': Icons.local_fire_department,
    'mainWorkout': Icons.fitness_center,
    'coolDown': Icons.spa,
    'nutritionTips': Icons.restaurant,
  };

  static Color getColor(String sectionKey) =>
      _sectionColors[sectionKey] ?? AppColors.accent;

  static IconData getIcon(String sectionKey) =>
      _sectionIcons[sectionKey] ?? Icons.fitness_center;

  static String getDisplayTitle(String sectionKey) {
    const titles = {
      'warmUp': 'Warm Up',
      'mainWorkout': 'Main Workout',
      'coolDown': 'Cool Down',
      'nutritionTips': 'Nutrition Tips',
    };
    return titles[sectionKey] ?? sectionKey;
  }

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

// In generate_workout_screen.dart
Widget _buildWorkoutSection(String title, dynamic content, {Color? color, bool isActive = false}) {
  final sectionColor = color ?? WorkoutSectionUtils.getColor(title);
  final icon = WorkoutSectionUtils.getIcon(title);
  final displayTitle = WorkoutSectionUtils.getDisplayTitle(title);
  // ... rest of the widget is much cleaner
}
// ✅ All utilities in one place
// ✅ Easy to maintain and update
// ✅ Can be reused across the app
// ✅ Screen class is cleaner
```

---

## Summary Table

| Aspect | Before | After |
|--------|--------|-------|
| **File Organization** | 1 monolithic file | 6 focused files |
| **Color Management** | Scattered constants | `AppColors` class |
| **Constants** | Hardcoded everywhere | `AppConstants` class |
| **API Logic** | In screen state | `GeminiService` |
| **Parsing Logic** | 100+ lines in screen | `WorkoutPlanParserService` |
| **Utilities** | Methods in screen | `WorkoutSectionUtils` |
| **Testability** | Hard to test | Easy to unit test |
| **Reusability** | Limited | High across modules |
| **Maintainability** | Difficult | Simple |
| **Scalability** | Poor | Excellent |

---

## Key Achievements

✅ **Separation of Concerns**: Each module has a single responsibility  
✅ **DRY Principle**: No code duplication across files  
✅ **SOLID Principles**: Better adherence to design principles  
✅ **Testability**: Services can be tested independently  
✅ **Maintainability**: Changes are localized to specific files  
✅ **Scalability**: Easy to add new features without modifying existing code
