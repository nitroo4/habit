// lib/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    habits = MockData.getMockHabits();
  }

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  DateTime _getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  int _getWeekdayOffset(DateTime date) {
    final firstDay = _getFirstDayOfMonth(date);
    return firstDay.weekday - 1;
  }

  bool _isDayCompleted(DateTime date) {
    if (habits.isEmpty) return false;
    final completedCount = habits.where((h) => h.isCompletedOn(date)).length;
    return completedCount > 0;
  }

  double _getDayCompletionRate(DateTime date) {
    if (habits.isEmpty) return 0;
    final completedCount = habits.where((h) => h.isCompletedOn(date)).length;
    return completedCount / habits.length;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_currentMonth);
    final offset = _getWeekdayOffset(_currentMonth);
    final totalCells = ((offset + daysInMonth) / 7).ceil() * 7;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MMMM yyyy', 'fr_FR').format(_currentMonth),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: const Icon(Icons.chevron_left),
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: const Icon(Icons.chevron_right),
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(bottom: 16),
              centerTitle: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FadeInUp(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((day) {
                            return Expanded(
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1,
                          ),
                          itemCount: totalCells,
                          itemBuilder: (context, index) {
                            final dayNumber = index - offset + 1;
                            final isValid = dayNumber >= 1 && dayNumber <= daysInMonth;

                            if (!isValid) {
                              return Container();
                            }

                            final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
                            final isToday = date.year == DateTime.now().year &&
                                date.month == DateTime.now().month &&
                                date.day == DateTime.now().day;
                            final isCompleted = _isDayCompleted(date);
                            final completionRate = _getDayCompletionRate(date);

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? AppTheme.primaryColor.withOpacity(0.2)
                                    : Colors.transparent,
                                border: isToday
                                    ? Border.all(color: AppTheme.primaryColor, width: 2)
                                    : null,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (completionRate > 0 && completionRate < 1)
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        value: completionRate,
                                        strokeWidth: 3,
                                        backgroundColor: Colors.grey.withOpacity(0.2),
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                      ),
                                    ),
                                  Text(
                                    dayNumber.toString(),
                                    style: GoogleFonts.inter(
                                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                      color: isCompleted
                                          ? AppTheme.primaryColor
                                          : Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildStatisticsCard(),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final now = DateTime.now();
    final monthStart = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final monthEnd = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    int totalCompleted = 0;
    int totalDays = 0;

    for (int day = 1; day <= monthEnd.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      totalDays++;
      if (_isDayCompleted(date)) {
        totalCompleted++;
      }
    }

    final bestDay = _getBestDay();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.secondaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques du mois',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  'Jours actifs',
                  '$totalCompleted/$totalDays',
                  Icons.calendar_today,
                  AppTheme.successColor,
                ),
              ),
              Expanded(
                child: _buildMiniStat(
                  'Taux de réussite',
                  '${((totalCompleted / totalDays) * 100).toInt()}%',
                  Icons.percent,
                  AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  'Meilleur jour',
                  bestDay,
                  Icons.emoji_events,
                  AppTheme.warningColor,
                ),
              ),
              Expanded(
                child: _buildMiniStat(
                  'Habitudes totales',
                  '${habits.length}',
                  Icons.checklist,
                  AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getBestDay() {
    int maxCompleted = 0;
    String bestDay = 'Aucun';

    for (int day = 1; day <= _getDaysInMonth(_currentMonth); day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final completed = habits.where((h) => h.isCompletedOn(date)).length;
      if (completed > maxCompleted) {
        maxCompleted = completed;
        bestDay = 'Jour $day';
      }
    }

    return bestDay;
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}