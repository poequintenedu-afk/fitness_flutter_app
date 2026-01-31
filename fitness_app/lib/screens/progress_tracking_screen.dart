import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressTrackingScreen extends StatefulWidget {
  const ProgressTrackingScreen({super.key});

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FitnessProvider>(
        builder: (context, fitnessProvider, _) {
          final weeklyData = fitnessProvider.getWeeklyStepsByDay();
          final totalWeeklySteps = weeklyData.values.fold(0, (sum, val) => sum + val);
          final averageSteps = weeklyData.isEmpty 
              ? 0 
              : totalWeeklySteps ~/ weeklyData.length;

          return CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: FadeTransition(
                    opacity: _fadeController.drive(
                      Tween(begin: 0.0, end: 1.0),
                    ),
                    child: Text(
                      'Progress Tracking',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF10B981),
                          Color(0xFF059669),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.trending_up,
                        size: 50,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekly Stats Cards
                      SlideTransition(
                        position: _slideController.drive(
                          Tween(
                            begin: Offset(-0.3, 0),
                            end: Offset.zero,
                          ),
                        ),
                        child: _buildStatsCard(
                          'Weekly Total',
                          totalWeeklySteps.toString(),
                          'steps',
                          Color(0xFF10B981),
                          Icons.trending_up,
                        ),
                      ),
                      SizedBox(height: 12),

                      SlideTransition(
                        position: _slideController.drive(
                          Tween(
                            begin: Offset(0.3, 0),
                            end: Offset.zero,
                          ),
                        ),
                        child: _buildStatsCard(
                          'Daily Average',
                          averageSteps.toString(),
                          'steps',
                          Color(0xFF3B82F6),
                          Icons.equalizer,
                        ),
                      ),
                      SizedBox(height: 28),

                      // Weekly Chart
                      Text(
                        'Weekly Progress Chart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 16),

                      FadeTransition(
                        opacity: _fadeController.drive(
                          Tween(begin: 0.0, end: 1.0),
                        ),
                        child: _buildWeeklyChart(weeklyData),
                      ),
                      SizedBox(height: 28),

                      // Daily Breakdown
                      Text(
                        'Daily Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 12),

                      SlideTransition(
                        position: _slideController.drive(
                          Tween(
                            begin: Offset(0.3, 0),
                            end: Offset.zero,
                          ),
                        ),
                        child: _buildDailyBreakdown(weeklyData),
                      ),
                      SizedBox(height: 20),

                      // Motivation Section
                      _buildMotivationCard(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(Map<String, int> weeklyData) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxValue = weeklyData.values.isEmpty
        ? 1000.0
        : (weeklyData.values.reduce((a, b) => a > b ? a : b).toDouble());

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < days.length; i++) {
      final steps = weeklyData[days[i]] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: steps.toDouble(),
              color: _getColorForValue(steps),
              width: 14,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            maxY: maxValue * 1.1,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      days[value.toInt()],
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${(value / 1000).toInt()}K',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 11,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: maxValue / 4,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Color(0xFFE5E7EB),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  Color _getColorForValue(int steps) {
    if (steps >= 10000) return Color(0xFF10B981);
    if (steps >= 7000) return Color(0xFF3B82F6);
    if (steps >= 5000) return Color(0xFFF59E0B);
    return Color(0xFFF87171);
  }

  Widget _buildDailyBreakdown(Map<String, int> weeklyData) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Column(
      children: List.generate(
        days.length,
        (index) {
          final day = days[index];
          final steps = weeklyData[day] ?? 0;
          final percentage = steps / 12000; // Assuming 12000 as max goal

          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E7EB), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        '$steps steps',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorForValue(steps),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMotivationCard() {
    final messages = [
      '🎉 Keep up the great work!',
      '💪 You\'re doing amazing!',
      '🏃 Don\'t stop now!',
      '⭐ Stay motivated!',
      '🚀 You\'re crushing it!',
    ];
    
    final message = messages[DateTime.now().day % messages.length];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Motivation',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
