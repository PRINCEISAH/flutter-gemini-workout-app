import 'package:flutter/material.dart';
import 'dart:async';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'services/gemini_service.dart';
import 'services/workout_plan_parser_service.dart';
import 'utils/workout_section_utils.dart';

class GenerateWorkoutPlanScreen extends StatefulWidget {
  const GenerateWorkoutPlanScreen({super.key});

  @override
  _GenerateWorkoutPlanScreenState createState() =>
      _GenerateWorkoutPlanScreenState();
}

class _GenerateWorkoutPlanScreenState extends State<GenerateWorkoutPlanScreen>
    with TickerProviderStateMixin {
  // Dependencies
  late final GeminiService _geminiService;
  late final WorkoutPlanParserService _parserService;

  // UI State
  String? _selectedGoal;
  String? _selectedExperience;
  String? _selectedDuration;
  bool _isLoading = false;
  String? _rawResponse;
  Map<String, dynamic>? _workoutPlan;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // Workout execution state
  int _currentSectionIndex = 0;
  bool _workoutStarted = false;
  int _countdownSeconds = AppConstants.countdownDuration;
  Timer? _countdownTimer;
  bool _isCountingDown = false;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService();
    _parserService = WorkoutPlanParserService();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.fadeDuration),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.slideDuration),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
        if (_countdownSeconds < 0) {
          timer.cancel();
          _countdownTimer = null;
          _isCountingDown = false;
          _workoutStarted = true;
          _currentSectionIndex = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Generate Workout Plan',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              _buildGoalSelector(),
              const SizedBox(height: 24),
              _buildExperienceSelector(),
              const SizedBox(height: 24),
              _buildDurationSelector(),
              const SizedBox(height: 32),
              _buildGenerateButton(),
              const SizedBox(height: 32),
              if (_workoutPlan != null || _rawResponse != null)
                _buildWorkoutPlanDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    int selectedCount = 0;
    if (_selectedGoal != null) selectedCount++;
    if (_selectedExperience != null) selectedCount++;
    if (_selectedDuration != null) selectedCount++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Setup Progress',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              '$selectedCount/3',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: selectedCount / 3,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fitness Goal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AppConstants.fitnessGoals
              .map((goal) => _buildSelectableChip(
                    label: goal,
                    selected: _selectedGoal == goal,
                    onTap: () => setState(() => _selectedGoal = goal),
                    icon: WorkoutSectionUtils.getGoalIcon(goal),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Experience Level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: AppConstants.experienceLevels
              .map((level) => Expanded(
                    child: _buildSelectableButton(
                      label: level,
                      selected: _selectedExperience == level,
                      onTap: () => setState(() => _selectedExperience = level),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Workout Duration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AppConstants.durations
              .map((duration) => _buildSelectableChip(
                    label: duration,
                    selected: _selectedDuration == duration,
                    onTap: () => setState(() => _selectedDuration = duration),
                    icon: Icons.schedule,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSelectableChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: selected ? AppColors.accent : Colors.white.withOpacity(0.2),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18,
                color: selected ? AppColors.textWhite : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.textWhite : AppColors.textMuted,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.secondary : Colors.white.withOpacity(0.05),
          border: Border.all(
            color:
                selected ? AppColors.secondary : Colors.white.withOpacity(0.2),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.textWhite : AppColors.textMuted,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    bool isEnabled = _selectedGoal != null &&
        _selectedExperience != null &&
        _selectedDuration != null &&
        !_isLoading;

    return GestureDetector(
      onTap: isEnabled ? _generateWorkoutPlan : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isEnabled
                ? [AppColors.accent, AppColors.accent.withOpacity(0.8)]
                : [Colors.grey, Colors.grey.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Generate Workout Plan',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildWorkoutPlanDisplay() {
    if (_workoutPlan != null) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(_fadeController),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Personalized Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 16),
            ..._workoutPlan!.entries
                .map((entry) => _buildWorkoutSection(entry.key, entry.value)),
          ],
        ),
      );
    } else if (_rawResponse != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Response',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _rawResponse!,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildWorkoutSection(String title, dynamic content,
      {Color? color, bool isActive = false}) {
    final sectionColor = color ?? WorkoutSectionUtils.getColor(title);
    final icon = WorkoutSectionUtils.getIcon(title);
    final displayTitle = WorkoutSectionUtils.getDisplayTitle(title);

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: sectionColor.withOpacity(0.1),
          border: Border.all(
            color: isActive ? sectionColor : sectionColor.withOpacity(0.3),
            width: isActive ? 2 : 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: sectionColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            initiallyExpanded: isActive,
            leading: Icon(icon, color: sectionColor, size: 28),
            title: Row(
              children: [
                Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
                if (isActive)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sectionColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: sectionColor, width: 1),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: sectionColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content is List)
                      ...content
                          .asMap()
                          .entries
                          .map((entry) => _buildExerciseItem(
                                entry.value.toString(),
                                entry.key + 1,
                                sectionColor,
                              ))
                    else
                      Text(
                        content.toString(),
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String text, int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getGoalIcon(String goal) {
    return WorkoutSectionUtils.getGoalIcon(goal);
  }

  String _formatSectionTitle(String title) {
    return WorkoutSectionUtils.getDisplayTitle(title);
  }

  Future<void> _generateWorkoutPlan() async {
    if (_selectedGoal == null ||
        _selectedExperience == null ||
        _selectedDuration == null) {
      return;
    }

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

        // Show modal after successful workout generation
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && _workoutPlan != null) {
            _showWorkoutModal();
          }
        });
      } else {
        throw Exception('No response from Gemini');
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

  void _showWorkoutModal() {
    if (_workoutPlan == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: _buildWorkoutModalContent(),
      ),
    );
  }

  Widget _buildWorkoutModalContent() {
    if (_isCountingDown) {
      return _buildCountdownView();
    }
    if (_workoutStarted) {
      return _buildActiveWorkoutModal();
    }
    return _buildWorkoutPreviewModal();
  }

  Widget _buildCountdownView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Get Ready!',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 3),
                color: AppColors.primary,
              ),
              child: Center(
                child: Text(
                  '$_countdownSeconds',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              _countdownSeconds == 1 ? 'Starting...' : 'Prepare yourself',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutPreviewModal() {
    final sections = [
      ('Warm Up', _workoutPlan?['warmUp'] ?? [], const Color(0xFFFF9800)),
      (
        'Main Workout',
        _workoutPlan?['mainWorkout'] ?? [],
        const Color(0xFFE91E63)
      ),
      ('Cool Down', _workoutPlan?['coolDown'] ?? [], const Color(0xFF2196F3)),
      (
        'Nutrition Tips',
        _workoutPlan?['nutritionTips'] ?? [],
        const Color(0xFF4CAF50)
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Personalized Workout',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            const Icon(Icons.close, color: AppColors.textWhite),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '$_selectedGoal • $_selectedExperience • $_selectedDuration',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Sections preview
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  for (int i = 0; i < sections.length; i++)
                    _buildSectionPreviewCard(
                      title: sections[i].$1,
                      items: sections[i].$2,
                      color: sections[i].$3,
                    ),
                ],
              ),
            ),
          ),
          // Start button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white10, width: 1),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startCountdown,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'START WORKOUT',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionPreviewCard({
    required String title,
    required List<dynamic> items,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${items.length} items',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveWorkoutModal() {
    if (_workoutPlan == null) {
      return const SizedBox.shrink();
    }

    final sections = [
      {
        'title': 'Warm Up',
        'items': _workoutPlan?['warmUp'] ?? [],
        'color': const Color(0xFFFF9800),
      },
      {
        'title': 'Main Workout',
        'items': _workoutPlan?['mainWorkout'] ?? [],
        'color': const Color(0xFFE91E63),
      },
      {
        'title': 'Cool Down',
        'items': _workoutPlan?['coolDown'] ?? [],
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Nutrition Tips',
        'items': _workoutPlan?['nutritionTips'] ?? [],
        'color': const Color(0xFF4CAF50),
      },
    ];

    final currentSection = sections[_currentSectionIndex];
    final progress = (_currentSectionIndex + 1) / sections.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress header
          _buildSectionHeader(
            currentSection['title'] as String,
            currentSection['color'] as Color,
            progress,
          ),
          // Section content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildWorkoutSection(
                currentSection['title'] as String,
                currentSection['items'] as List<dynamic>,
                color: currentSection['color'] as Color,
                isActive: true,
              ),
            ),
          ),
          // Navigation footer
          _buildNavigationFooter(sections.length),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fitness_center,
                        color: AppColors.textWhite, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color, width: 1),
                ),
                child: Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Section ${_currentSectionIndex + 1} of 4',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationFooter(int totalSections) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Previous button
          if (_currentSectionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentSectionIndex--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'PREVIOUS',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'EXIT',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),
          // Next/Complete button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_currentSectionIndex < totalSections - 1) {
                  setState(() {
                    _currentSectionIndex++;
                  });
                } else {
                  // Completed workout
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Great job! Workout completed! 🎉'),
                      backgroundColor: AppColors.success,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Reset state
                  setState(() {
                    _workoutStarted = false;
                    _currentSectionIndex = 0;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentSectionIndex < totalSections - 1 ? 'NEXT' : 'COMPLETE',
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _parseWorkoutPlan(String text) {
    return _parserService.parse(text);
  }
}
