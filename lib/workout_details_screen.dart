import 'package:flutter/material.dart';

class QuickWorkoutDetailScreen extends StatelessWidget {
  static const double _contentPadding = 16.0;
  static const double _spacingMedium = 16.0;

  final String workoutName;
  final String gifUrl;
  final String description;
  final List<String> exercises;
  final String duration;
  final String difficulty;

  const QuickWorkoutDetailScreen({
    super.key,
    required this.workoutName,
    required this.gifUrl,
    required this.description,
    required this.exercises,
    required this.duration,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workoutName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroImage(gifUrl: gifUrl),
            Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WorkoutDetails(duration: duration, difficulty: difficulty),
                  const SizedBox(height: _spacingMedium),
                  Description(description: description),
                  const SizedBox(height: _spacingMedium),
                  ExercisesList(exercises: exercises),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  static const double _imageHeight = 200;

  final String gifUrl;

  const HeroImage({super.key, required this.gifUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      gifUrl,
      height: _imageHeight,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: _imageHeight,
          width: double.infinity,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }
}

class WorkoutDetails extends StatelessWidget {
  final String duration;
  final String difficulty;

  const WorkoutDetails({
    super.key,
    required this.duration,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Duration: $duration', style: textTheme.titleMedium),
        Text('Difficulty: $difficulty', style: textTheme.titleMedium),
      ],
    );
  }
}

class Description extends StatelessWidget {
  static const double _spacingSmall = 8.0;

  final String description;

  const Description({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: textTheme.titleLarge),
        const SizedBox(height: _spacingSmall),
        Text(description),
      ],
    );
  }
}

class ExercisesList extends StatelessWidget {
  static const double _spacingSmall = 8.0;
  static const double _exercisePadding = 8.0;

  final List<String> exercises;

  const ExercisesList({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exercises', style: textTheme.titleLarge),
        const SizedBox(height: _spacingSmall),
        ...exercises.map(
          (exercise) => Padding(
            padding: const EdgeInsets.only(bottom: _exercisePadding),
            child: Text('• $exercise'),
          ),
        ),
      ],
    );
  }
}
