import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';

class WorkoutPlanningScreen extends StatefulWidget {
  const WorkoutPlanningScreen({super.key});

  @override
  State<WorkoutPlanningScreen> createState() => _WorkoutPlanningScreenState();
}

class _WorkoutPlanningScreenState extends State<WorkoutPlanningScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  String _selectedLevel = 'Beginner';
  late int _selectedGoal;
  String? _selectedPlan;

  final Map<String, int> levelGoals = {
    'Beginner': 5000,
    'Intermediate': 8000,
    'Advanced': 12000,
  };

  @override
  void initState() {
    super.initState();
    _selectedGoal = levelGoals['Beginner'] ?? 5000;
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: FadeTransition(
                opacity: _fadeController.drive(
                  Tween(begin: 0.0, end: 1.0),
                ),
                child: Text('Workout Planning'),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                ),
                child: Center(
                  child: SlideTransition(
                    position: _slideController.drive(
                      Tween(
                        begin: Offset(0, 0.5),
                        end: Offset.zero,
                      ),
                    ),
                    child: ScaleTransition(
                      scale: _slideController.drive(
                        Tween(begin: 0.8, end: 1.0),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fitness Level Selection
                  _buildSectionTitle('Select Your Fitness Level'),
                  SizedBox(height: 12),
                  _buildFitnessLevelCards(),
                  SizedBox(height: 32),

                  // Daily Step Goal
                  _buildSectionTitle('Daily Step Goal'),
                  SizedBox(height: 12),
                  _buildGoalSlider(),
                  SizedBox(height: 32),

                  // Workout Plans
                  _buildSectionTitle('Choose a Workout Plan'),
                  SizedBox(height: 12),
                  _buildWorkoutPlans(),
                  SizedBox(height: 32),

                  // Save Button
                  _buildSaveButton(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return ScaleTransition(
      scale: _fadeController.drive(Tween(begin: 0.8, end: 1.0)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildFitnessLevelCards() {
    return Column(
      children: [
        Row(
          children: [
            _buildLevelCard('Beginner', 0),
            SizedBox(width: 12),
            _buildLevelCard('Intermediate', 1),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildLevelCard('Advanced', 2),
            SizedBox(width: 12),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelCard(String level, int index) {
    bool isSelected = _selectedLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLevel = level;
            _selectedGoal = levelGoals[level] ?? 5000;
            _selectedPlan = null;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                : LinearGradient(
                    colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Color(0xFF6366F1) : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconForLevel(level),
                size: 32,
                color: isSelected ? Colors.white : Color(0xFF6B7280),
              ),
              SizedBox(height: 8),
              Text(
                level,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForLevel(String level) {
    return switch (level) {
      'Beginner' => Icons.sentiment_very_satisfied,
      'Intermediate' => Icons.sentiment_satisfied,
      'Advanced' => Icons.sentiment_satisfied_alt,
      _ => Icons.fitness_center,
    };
  }

  Widget _buildGoalSlider() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _pulseController.drive(Tween(begin: 1.0, end: 1.05)),
            child: Text(
              '$_selectedGoal Steps',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
          SizedBox(height: 16),
          Slider(
            value: _selectedGoal.toDouble(),
            min: 3000,
            max: 20000,
            divisions: 17,
            activeColor: Color(0xFF6366F1),
            inactiveColor: Color(0xFFD1D5DB),
            onChanged: (value) {
              setState(() {
                _selectedGoal = value.toInt();
              });
            },
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('3000', style: TextStyle(color: Color(0xFF9CA3AF))),
              Text('20000', style: TextStyle(color: Color(0xFF9CA3AF))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPlans() {
    final plans = _getPlansByLevel(_selectedLevel);
    
    return Column(
      children: List.generate(
        plans.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _buildPlanCard(plans[index], index),
        ),
      ),
    );
  }

  Widget _buildPlanCard(String plan, int index) {
    bool isSelected = _selectedPlan == plan;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = isSelected ? null : plan;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: isSelected ? Color(0xFF6366F1).withValues(alpha: 0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Color(0xFF6366F1) : Color(0xFFD1D5DB),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.directions_walk,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    plan,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF6366F1),
                  ),
              ],
            ),
            if (isSelected) ...[
              SizedBox(height: 12),
              Text(
                'This plan is designed for your fitness level. Follow it consistently for best results.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<String> _getPlansByLevel(String level) {
    return switch (level) {
      'Beginner' => [
        'Morning Walk (5K steps)',
        'Evening Stroll (3K steps)',
      ],
      'Intermediate' => [
        'Brisk Walk (8K steps)',
        'Morning Jog + Walk (10K steps)',
      ],
      'Advanced' => [
        'Speed Walking Challenge (12K steps)',
        'Running Session (15K steps)',
      ],
      _ => [],
    };
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedPlan != null ? _saveGoal : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6366F1),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          _selectedPlan == null ? 'Select a plan to continue' : 'Save My Goal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _saveGoal() {
    context.read<FitnessProvider>().setFitnessGoal(
      _selectedLevel,
      _selectedGoal,
      _selectedPlan ?? 'Custom Plan',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Goal saved! Start tracking your steps.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF6366F1),
      ),
    );

    Navigator.pop(context);
  }
}
