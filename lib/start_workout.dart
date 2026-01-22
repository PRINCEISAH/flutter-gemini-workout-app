import 'package:flutter/material.dart';
import 'package:workoutapp/workout_details_screen.dart';

class QuickStartWorkout extends StatelessWidget {
  static const String _titleText = 'Quick Start';
  static const String _subtitleText =
      'Need a quick workout? Try our pre-made plans!';
  static const String _buttonText = 'Start Now';
  static const String _modalTitle = 'Choose a Quick Workout';

  static const double _cardElevation = 4.0;
  static const double _cardPadding = 20.0;
  static const double _spacingSmall = 10.0;
  static const double _spacingMedium = 15.0;
  static const double _spacingLarge = 16.0;
  static const double _borderRadius = 15.0;
  static const double _modalBorderRadius = 20.0;

  final List<QuickWorkoutModel> quickWorkouts = [
    const QuickWorkoutModel(
      name: 'Full Body HIIT',
      duration: '20 min',
      difficulty: 'Intermediate',
      gifUrl: 'https://j.gifs.com/oYBymz@large.gif?download=true',
      description:
          'This High-Intensity Interval Training (HIIT) workout targets your entire body, helping you burn calories and improve cardiovascular fitness.',
      exercises: [
        'Jumping jacks - 30 seconds',
        'Push-ups - 30 seconds',
        'Mountain climbers - 30 seconds',
        'Squat jumps - 30 seconds',
        'Burpees - 30 seconds',
        'Rest - 30 seconds',
        'Repeat circuit 3 times'
      ],
    ),
    const QuickWorkoutModel(
      name: 'Core Crusher',
      duration: '15 min',
      difficulty: 'Beginner',
      gifUrl: 'https://example.com/core_crusher.gif',
      description:
          'Strengthen your core with this quick and effective workout. Perfect for beginners looking to build a strong foundation.',
      exercises: [
        'Plank hold - 30 seconds',
        'Crunches - 20 reps',
        'Russian twists - 30 seconds',
        'Leg raises - 15 reps',
        'Superman hold - 30 seconds',
        'Rest - 30 seconds',
        'Repeat circuit 2 times'
      ],
    ),
    const QuickWorkoutModel(
      name: 'Upper Body Strength',
      duration: '30 min',
      difficulty: 'Advanced',
      gifUrl: 'https://example.com/upper_body_strength.gif',
      description:
          'Challenge your upper body with this comprehensive strength workout. Suitable for those with some fitness experience looking to build muscle and strength.',
      exercises: [
        'Push-ups - 15 reps',
        'Dumbbell rows - 12 reps each arm',
        'Overhead press - 10 reps',
        'Tricep dips - 12 reps',
        'Bicep curls - 12 reps',
        'Rest - 60 seconds',
        'Repeat circuit 3 times'
      ],
    ),
  ];

  QuickStartWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _cardElevation,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(_cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            const SizedBox(height: _spacingSmall),
            _buildSubtitle(context),
            const SizedBox(height: _spacingMedium),
            _buildStartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      _titleText,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      _subtitleText,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showQuickWorkoutOptions(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
      ),
      child: const Text(_buttonText),
    );
  }

  void _showQuickWorkoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(_modalBorderRadius)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(_spacingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_modalTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: _spacingLarge),
              ...quickWorkouts
                  .map((workout) => _buildWorkoutTile(context, workout)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutTile(BuildContext context, QuickWorkoutModel workout) {
    return ListTile(
      title: Text(workout.name),
      subtitle: Text('${workout.duration} • ${workout.difficulty}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _startQuickWorkout(context, workout),
    );
  }

  void _startQuickWorkout(BuildContext context, QuickWorkoutModel workout) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuickWorkoutDetailScreen(
          workoutName: workout.name,
          gifUrl: workout.gifUrl,
          description: workout.description,
          exercises: workout.exercises,
          duration: workout.duration,
          difficulty: workout.difficulty,
        ),
      ),
    );
  }
}

class QuickWorkoutModel {
  final String name;
  final String duration;
  final String difficulty;
  final String gifUrl;
  final String description;
  final List<String> exercises;

  const QuickWorkoutModel({
    required this.name,
    required this.duration,
    required this.difficulty,
    required this.gifUrl,
    required this.description,
    required this.exercises,
  });
}
