# Codebase Organization - Quick Reference

## 📁 File Organization

### New Modules Created

```
lib/
├── constants/
│   ├── app_colors.dart                    (105 lines)
│   └── app_constants.dart                 (42 lines)
├── models/
│   └── workout_models.dart                (80 lines)
├── services/
│   ├── gemini_service.dart                (47 lines)
│   └── workout_plan_parser_service.dart   (97 lines)
└── utils/
    └── workout_section_utils.dart         (56 lines)
```

**Total New Code**: ~427 lines (organized and well-documented)
**Refactored Screen**: ~1,100 lines (cleaned up from 1,238)

---

## 🎯 Quick Navigation

### Need to change colors?
→ `lib/constants/app_colors.dart`

### Need to change app constants (goals, levels, durations)?
→ `lib/constants/app_constants.dart`

### Need to modify API communication?
→ `lib/services/gemini_service.dart`

### Need to fix response parsing?
→ `lib/services/workout_plan_parser_service.dart`

### Need to add/modify workout section icons or titles?
→ `lib/utils/workout_section_utils.dart`

### Need to modify the UI screen?
→ `lib/generate_workout_screen.dart`

---

## 🔧 Common Tasks

### Add a new fitness goal
1. Open `lib/constants/app_constants.dart`
2. Add to `fitnessGoals` list
3. Add icon mapping in `lib/utils/workout_section_utils.dart` if needed

### Change theme colors
1. Open `lib/constants/app_colors.dart`
2. Update the color constants
3. All screens automatically use the new colors

### Modify API prompt
1. Open `lib/services/gemini_service.dart`
2. Edit the `_buildPrompt()` method
3. No UI changes needed

### Debug workout parsing
1. Open `lib/services/workout_plan_parser_service.dart`
2. The `parse()` method is the entry point
3. Add debug prints here to trace issues

### Update UI helpers/utilities
1. Open `lib/utils/workout_section_utils.dart`
2. Add or modify helper methods
3. Use from the screen via `WorkoutSectionUtils.methodName()`

---

## 💡 Design Patterns Used

### Singleton Pattern
- `GeminiService`: Only one instance needed throughout the app
- `WorkoutPlanParserService`: Only one instance needed throughout the app

### Service Locator Pattern
- Services are created and managed by the screen state
- Can easily be replaced with dependency injection later

### Utility Classes
- `WorkoutSectionUtils`: Static methods for common operations
- No instance creation needed, functions accessed directly

---

## 📊 Metrics

### Before Refactoring
- 1 monolithic file: `generate_workout_screen.dart` (1,238 lines)
- Mixed concerns: UI, API, parsing, utilities
- 5 hardcoded color constants
- Repeated icon/color mappings
- Difficult to test

### After Refactoring
- 1 main screen: `generate_workout_screen.dart` (~1,100 lines, 11% reduction)
- 6 specialized modules: ~427 lines
- **Total codebase still efficient** but much better organized
- Centralized color management
- Single source of truth for all configuration
- Easily testable components

---

## ✅ Validation

All modules are:
- ✓ Properly documented with comments
- ✓ Following Dart conventions
- ✓ Using meaningful class and method names
- ✓ Implementing single responsibility principle
- ✓ Ready for unit testing

---

## 🚀 Next Steps (Optional Enhancements)

1. **Add Unit Tests** for services
2. **Extract Widget Classes** for custom widgets
3. **Add State Management** (Provider/Bloc) for complex state
4. **Create Theme Service** for dynamic theming
5. **Add Error Handling Service** for centralized error management
6. **Add Logging Service** for debugging

---

## 📞 Support

Each module has:
- Clear class/method names
- Inline documentation
- Logical grouping of related functionality
- Minimal dependencies between modules

If you need to extend functionality:
1. Identify which module it belongs to
2. Add the feature there
3. Import and use in the screen or other services
