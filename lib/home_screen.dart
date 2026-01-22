import 'package:flutter/material.dart';
import 'generate_workout_screen.dart';
import 'start_workout.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingMedium),
                _buildGreeting(),
                const SizedBox(height: AppConstants.spacingXLarge),
                _buildProgressSection(),
                const SizedBox(height: AppConstants.spacingLarge),
                _buildFeaturedSection(context),
                const SizedBox(height: AppConstants.spacingLarge),
                _buildQuickActionsGrid(context),
                const SizedBox(height: AppConstants.spacingLarge),
                QuickStartWorkout(),
                const SizedBox(height: AppConstants.spacingMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConstants.greeting,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Container(
          height: 4,
          width: 80,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConstants.progressTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        Row(
          children: [
            _buildStatCard('0', AppConstants.caloriesTitle, AppColors.accent),
            const SizedBox(width: AppConstants.spacingMedium),
            _buildStatCard(
                '0', AppConstants.workoutsTitle, AppColors.secondary),
            const SizedBox(width: AppConstants.spacingMedium),
            _buildStatCard('0', AppConstants.streakTitle, AppColors.success),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        height: AppConstants.smallCardHeight,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GenerateWorkoutPlanScreen(),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent,
              AppColors.accent.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        padding: const EdgeInsets.all(AppConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(AppConstants.spacingSmall),
              child: const Icon(
                Icons.auto_awesome,
                size: AppConstants.largeIconSize,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            const Text(
              AppConstants.generatePlanTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            const Text(
              AppConstants.generatePlanDescription,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppConstants.tapToStart,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConstants.quickActionsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        Row(
          children: [
            _buildQuickActionCard(
              Icons.timer,
              AppConstants.timerLabel,
              AppColors.secondary,
              () {},
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            _buildQuickActionCard(
              Icons.bar_chart,
              AppConstants.statsLabel,
              AppColors.success,
              () {},
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            _buildQuickActionCard(
              Icons.favorite,
              AppConstants.healthLabel,
              AppColors.warning,
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: AppConstants.smallCardHeight,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppConstants.largeIconSize,
                color: color,
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
