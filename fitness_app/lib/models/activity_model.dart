import 'package:intl/intl.dart';

class DailyActivity {
  final String id;
  final DateTime date;
  final int steps;
  final double calories;
  final String workoutPlan;

  DailyActivity({
    required this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.workoutPlan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'steps': steps,
      'calories': calories,
      'workoutPlan': workoutPlan,
    };
  }

  factory DailyActivity.fromJson(Map<String, dynamic> json) {
    return DailyActivity(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      steps: json['steps'] as int,
      calories: (json['calories'] as num).toDouble(),
      workoutPlan: json['workoutPlan'] as String,
    );
  }

  String get dateStr => DateFormat('MMM dd, yyyy').format(date);
}

class FitnessGoal {
  final String fitnessLevel; // Beginner, Intermediate, Advanced
  final int dailyStepGoal;
  final String workoutPlan;

  FitnessGoal({
    required this.fitnessLevel,
    required this.dailyStepGoal,
    required this.workoutPlan,
  });

  Map<String, dynamic> toJson() {
    return {
      'fitnessLevel': fitnessLevel,
      'dailyStepGoal': dailyStepGoal,
      'workoutPlan': workoutPlan,
    };
  }

  factory FitnessGoal.fromJson(Map<String, dynamic> json) {
    return FitnessGoal(
      fitnessLevel: json['fitnessLevel'] as String,
      dailyStepGoal: json['dailyStepGoal'] as int,
      workoutPlan: json['workoutPlan'] as String,
    );
  }
}

class WorkoutPlan {
  final String name;
  final String description;
  final int targetSteps;
  final int estimatedMinutes;
  final List<String> exercises;

  WorkoutPlan({
    required this.name,
    required this.description,
    required this.targetSteps,
    required this.estimatedMinutes,
    required this.exercises,
  });
}

// Predefined workout plans based on fitness level
class WorkoutPlans {
  static final Map<String, List<WorkoutPlan>> plans = {
    'Beginner': [
      WorkoutPlan(
        name: 'Morning Walk',
        description: 'Easy-paced morning walk to start your day',
        targetSteps: 5000,
        estimatedMinutes: 45,
        exercises: [
          'Walk at comfortable pace (3 mph)',
          'Take breaks as needed',
          'Stay hydrated',
        ],
      ),
      WorkoutPlan(
        name: 'Evening Stroll',
        description: 'Relaxing evening walk',
        targetSteps: 3000,
        estimatedMinutes: 30,
        exercises: [
          'Light walking',
          'Enjoy the surroundings',
          'Cool down gradually',
        ],
      ),
    ],
    'Intermediate': [
      WorkoutPlan(
        name: 'Brisk Walk',
        description: 'Fast-paced walking session',
        targetSteps: 8000,
        estimatedMinutes: 60,
        exercises: [
          'Walk at brisk pace (4 mph)',
          'Include some intervals',
          'Maintain steady heart rate',
        ],
      ),
      WorkoutPlan(
        name: 'Morning Jog + Walk',
        description: 'Mix of jogging and walking',
        targetSteps: 10000,
        estimatedMinutes: 75,
        exercises: [
          'Warm-up walk (5 min)',
          'Alternate jog/walk intervals',
          'Cool-down walk',
        ],
      ),
    ],
    'Advanced': [
      WorkoutPlan(
        name: 'Speed Walking Challenge',
        description: 'High-intensity walking',
        targetSteps: 12000,
        estimatedMinutes: 75,
        exercises: [
          'Walk at speed (4.5+ mph)',
          'Include inclines',
          'Maintain high intensity',
        ],
      ),
      WorkoutPlan(
        name: 'Running Session',
        description: 'Running with intervals',
        targetSteps: 15000,
        estimatedMinutes: 90,
        exercises: [
          'Warm-up jog (5 min)',
          'High-speed intervals',
          'Tempo running',
          'Cool-down jog',
        ],
      ),
    ],
  };

  static List<WorkoutPlan> getPlansForLevel(String level) {
    return plans[level] ?? plans['Beginner']!;
  }

  static int getDefaultGoalForLevel(String level) {
    return switch (level) {
      'Beginner' => 5000,
      'Intermediate' => 8000,
      'Advanced' => 12000,
      _ => 5000,
    };
  }
}
