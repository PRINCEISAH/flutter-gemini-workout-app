# Workout App - AI-Powered Fitness Companion

A Flutter fitness app powered by **Google Gemini API** that generates personalized workout plans with an interactive execution interface.

## 🎯 Features

**Home Screen** | Modern dark theme with stats overview, progress tracker, and quick action buttons.

**AI Workout Generation** | Gemini API creates personalized plans based on fitness goal, experience level (Beginner/Intermediate/Advanced), and duration (20-60 min). Includes Warm Up, Main Workout, Cool Down, and Nutrition Tips.

**Interactive Execution** | Three-stage system: Preview modal → 3-sec countdown → Section-by-section navigation. Color-coded sections (Warm Up 🟠, Main 🔴, Cool Down 🔵, Nutrition 🟢) with progress bar, "ACTIVE" badges, and Next/Previous controls.

**Quick Start Templates** | Pre-built routines: Full Body HIIT (30min), Core Crusher (20min), Upper Body Strength (30min).
![Uploading simulator_screenshot_33740CB0-20F6-40E3-94E2-C0194C7613BD.png…]()

**Smooth Animations** | Fade/slide transitions, animated countdown display, expansion animations.

**Color Palette** | Dark: #1A1A2E | Orange: #FF6B35 | Blue: #004E89 | Green: #1EBE73

## 🔧 Tech Stack

- **Flutter** + **Dart**
- **Google Gemini API** (`flutter_gemini`)
- **Firebase Core**, AnimationController, Material Design
- **Architecture**: StatefulWidget with TickerProviderStateMixin, async/await pattern, typed models

## 📱 Screens

| Screen | Purpose |
|--------|---------|
| `home_screen.dart` | Dashboard with stats & feature access |
| `generate_workout_screen.dart` | Custom workout creation & execution modal |<img width="1290" height="2796" alt="simulator_screenshot_2388A7AE-F794-46F8-8586-FD275C64F985" src="https://github.com/user-attachments/assets/686a6404-ffe7-4f9a-8125-502aacab821d" />
<img width="1290" height="2796" alt="simulator_screenshot_6A130747-F488-47EB-8FD8-81460ECB9CDA" src="https://github.com/user-attachments/assets/775c1979-33d4-47e6-bc63-3a50d8fc7cec" />
<img width="1290" height="2796" alt="simulator_screenshot_62387A9D-4564-4224-8346-3D2DC405C2A3" src="https://github.com/user-attachments/assets/60947e32-cfa8-4d99-b91c-4fe65345d07a" />
<img width="1290" height="2796" alt="simulator_screenshot_1762BD36-5910-4D46-9613-FEB07E6B4841" src="https://github.com/user-attachments/assets/6f4f850f-033f-4a04-beae-6838c57c231f" />



| `start_workout.dart` | Quick-start template selection (bottom sheet) |
| `workout_details_screen.dart` | Detailed workout info with hero image & exercises |

## 🚀 Quick Start

```bash
git clone https://github.com/PRINCEISAH/flutter-gemini-workout-app.git
cd workoutapp
flutter pub get
# Add Gemini API key to config/api_config.dart
flutter run
```

## 🎮 Usage

1. **Generate**: Select goal → Choose level → Pick duration → Tap "GENERATE"
2. **Execute**: Preview workout → Start countdown → Navigate sections → Complete
3. **Quick Start**: Select template → Start or view details

## 🚧 Planned Features

- Workout history & personal records
- Voice guidance during workouts
- Fitness tracker integration
- Offline mode
- Music playlists
- Social sharing

## 📄 License

MIT License - Open source for fitness enthusiasts

---

**Note**: Requires active internet connection for Gemini API during workout generation.
