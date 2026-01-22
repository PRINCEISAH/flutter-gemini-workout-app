# Workout App - AI-Powered Fitness Companion

A modern Flutter fitness application powered by Google Gemini API that generates personalized AI-driven workout plans and provides an interactive, engaging workout execution experience.

## 🎯 Features

### 🏠 Home Screen
- **Modern Dark Theme**: Professional fitness app design with custom dark color palette
- **Progress Indicator**: Visual setup progress tracker showing completion status
- **Stats Overview**: Display workout metrics (Calories, Workouts, Streak)
- **Featured Workout Section**: Eye-catching gradient card for generating new workouts
- **Quick Action Buttons**: Fast access to Timer, Stats, and Health features

### 🤖 AI-Powered Workout Generation
- **Gemini API Integration**: Generates personalized workout plans based on:
  - Fitness Goal (Lose weight, Build muscle, Improve cardiovascular health, etc.)
  - Experience Level (Beginner, Intermediate, Advanced)
  - Duration (20, 30, 45, or 60 minutes)
- **Smart Parsing**: Handles both JSON and plain text responses from Gemini
- **Structured Workouts**: Plans include Warm Up, Main Workout, Cool Down, and Nutrition Tips

### 🏋️ Interactive Modal Workout System
- **Three-Stage Execution**:
  1. **Preview Modal**: View all workout sections before starting
  2. **Countdown State**: 3-second "Get Ready!" countdown with large animated timer
  3. **Active Workout**: Section-by-section execution view

- **Section Navigation**:
  - **Next Button**: Advance to the next workout section
  - **Previous Button**: Go back to review previous sections
  - **Complete Button**: Finish workout with celebration message
  - **Exit Button**: Early exit from workout preview

- **Visual Indicators**:
  - Color-coded sections (Warm Up 🟠, Main Workout 🔴, Cool Down 🔵, Nutrition 🟢)
  - "ACTIVE" badge on current section
  - Enhanced borders and glow effects for active sections
  - Progress bar showing section completion percentage
  - Section counter (e.g., "Section 1 of 4")

### ⏱️ Countdown Timer
- 3-second preparation timer before workout starts
- Large, animated countdown display
- Automatic transition to active workout state
- Visual and interactive countdown management

### 📊 Progress Tracking
- Linear progress indicator for workout completion
- Visual feedback during workout execution
- Section-by-section progress tracking

### 💨 Smooth Animations
- Fade transitions for content loading
- Slide animations for smooth navigation
- Animated containers for state changes
- Expansion animations for workout sections

### 🏃 Quick Start Workouts
- Pre-built workout templates:
  - Full Body HIIT (30 minutes)
  - Core Crusher (20 minutes)
  - Upper Body Strength (30 minutes)
- Quick access to popular workout routines

### 📋 Workout Details Screen
- Comprehensive workout information display:
  - Hero image with error handling
  - Workout metadata (duration, difficulty level)
  - Full workout description
  - Detailed exercise list with numbering

## 🎨 Design & Theme

### Color Scheme
- **Primary**: #1A1A2E (Dark Background)
- **Accent Orange**: #FF6B35 (Primary Actions)
- **Secondary Blue**: #004E89 (Secondary Elements)
- **Success Green**: #1EBE73 (Positive Feedback)
- **Warning Orange**: #FFA500 (Alerts & Tips)

### Architecture
- **State Management**: StatefulWidget with TickerProviderStateMixin
- **Animation System**: Multiple AnimationController instances for smooth transitions
- **Type Safety**: Strongly typed models (QuickWorkoutModel) for data handling
- **Error Handling**: Comprehensive error management for API calls

## 📱 Screens

1. **Home Screen** (`home_screen.dart`)
   - Landing page with fitness overview
   - Quick access to all features

2. **Generate Workout Screen** (`generate_workout_screen.dart`)
   - Customizable workout plan generation
   - Interactive modal-based workout execution
   - Multi-step selection interface

3. **Start Workout Screen** (`start_workout.dart`)
   - Quick access to pre-built routines
   - Bottom sheet selection interface

4. **Workout Details Screen** (`workout_details_screen.dart`)
   - Detailed workout information
   - Exercise breakdown and instructions

## 🔧 Technical Stack

- **Framework**: Flutter
- **Language**: Dart
- **AI Engine**: Google Gemini API (flutter_gemini)
- **Async Programming**: Dart async/await with Timer for countdown
- **Animations**: Flutter AnimationController & transitions
- **Styling**: Material Design with custom theming

## 📦 Dependencies

- `flutter_gemini`: AI-powered workout generation
- `firebase_core`: Backend services
- Flutter Material Design

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/PRINCEISAH/flutter-gemini-workout-app.git
   cd workoutapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Gemini API**
   - Set up your Google Cloud project
   - Add your Gemini API key to the app configuration

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎮 How to Use

1. **Generate a Workout**:
   - Select your fitness goal
   - Choose your experience level
   - Pick your desired duration
   - Tap "GENERATE" to create a personalized plan

2. **Start Your Workout**:
   - Review the workout preview
   - Tap "START WORKOUT"
   - Watch the countdown
   - Follow the sections and use Next/Previous to navigate
   - Tap "COMPLETE" on the final section

3. **Quick Start**:
   - Browse pre-built workout templates
   - Select one to view details or start immediately

## 🚀 Future Enhancements

- Workout history tracking
- Personal records (PRs) logging
- Social sharing of workout achievements
- Voice guidance during workouts
- Integration with fitness trackers
- Offline workout mode
- Custom workout creation
- Music playlist integration

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Developer

Created with ❤️ for fitness enthusiasts

---

**Note**: This app requires an active internet connection for Gemini API calls during workout generation.
