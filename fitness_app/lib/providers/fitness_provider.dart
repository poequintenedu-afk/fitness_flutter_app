import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/activity_model.dart';

class FitnessProvider extends ChangeNotifier {
  static const double caloriesPerStep = 0.04; // 1 step ≈ 0.04 calories
  static const String _activitiesKey = 'daily_activities';
  static const String _goalKey = 'fitness_goal';

  int _currentSteps = 0;
  List<DailyActivity> _activities = [];
  FitnessGoal? _goal;
  late SharedPreferences _prefs;

  int get currentSteps => _currentSteps;
  double get currentCalories => _currentSteps * caloriesPerStep;
  List<DailyActivity> get activities => _activities;
  FitnessGoal? get goal => _goal;
  int get dailyGoal => _goal?.dailyStepGoal ?? 10000;
  double get goalProgress => _currentSteps / dailyGoal;

  FitnessProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadActivities();
    await _loadGoal();
    await _loadTodaySteps();
  }

  Future<void> _loadActivities() async {
    final json = _prefs.getString(_activitiesKey);
    if (json != null) {
      final data = jsonDecode(json) as List;
      _activities = data
          .map((item) => DailyActivity.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _loadGoal() async {
    final json = _prefs.getString(_goalKey);
    if (json != null) {
      _goal = FitnessGoal.fromJson(jsonDecode(json) as Map<String, dynamic>);
    }
    notifyListeners();
  }

  Future<void> _loadTodaySteps() async {
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month}-${today.day}';
    _currentSteps = _prefs.getInt('steps_$dateStr') ?? 0;
    notifyListeners();
  }

  Future<void> addSteps(int steps) async {
    _currentSteps += steps;
    
    // Save to shared preferences
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month}-${today.day}';
    await _prefs.setInt('steps_$dateStr', _currentSteps);
    
    // Update or create activity for today
    await _updateTodayActivity();
    notifyListeners();
  }

  Future<void> _updateTodayActivity() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    
    final existingIndex = _activities.indexWhere(
      (activity) => 
        activity.date.year == today.year &&
        activity.date.month == today.month &&
        activity.date.day == today.day,
    );

    if (existingIndex >= 0) {
      _activities[existingIndex] = DailyActivity(
        id: _activities[existingIndex].id,
        date: _activities[existingIndex].date,
        steps: _currentSteps,
        calories: _currentSteps * caloriesPerStep,
        workoutPlan: _activities[existingIndex].workoutPlan,
      );
    } else {
      _activities.add(
        DailyActivity(
          id: todayStr,
          date: today,
          steps: _currentSteps,
          calories: _currentSteps * caloriesPerStep,
          workoutPlan: _goal?.workoutPlan ?? 'No plan set',
        ),
      );
    }

    // Sort by date descending
    _activities.sort((a, b) => b.date.compareTo(a.date));
    
    // Save to shared preferences
    final json = _activities.map((a) => a.toJson()).toList();
    await _prefs.setString(_activitiesKey, jsonEncode(json));
  }

  Future<void> setFitnessGoal(String level, int dailyGoal, String workoutPlan) async {
    _goal = FitnessGoal(
      fitnessLevel: level,
      dailyStepGoal: dailyGoal,
      workoutPlan: workoutPlan,
    );
    
    final json = jsonEncode(_goal!.toJson());
    await _prefs.setString(_goalKey, json);
    
    await _updateTodayActivity();
    notifyListeners();
  }

  List<DailyActivity> getWeeklyData() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    return _activities
        .where((activity) => activity.date.isAfter(weekAgo))
        .toList();
  }

  Map<String, int> getWeeklyStepsByDay() {
    final weekData = getWeeklyData();
    final Map<String, int> stepsByDay = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    for (var activity in weekData) {
      final dayOfWeek = activity.date.weekday - 1; // 0 = Monday
      if (dayOfWeek >= 0 && dayOfWeek < 7) {
        stepsByDay[dayNames[dayOfWeek]] = activity.steps;
      }
    }

    return stepsByDay;
  }

  void resetDailySteps() async {
    _currentSteps = 0;
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month}-${today.day}';
    await _prefs.remove('steps_$dateStr');
    notifyListeners();
  }
}
