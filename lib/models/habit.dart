// lib/models/habit.dart
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int frequency; // 0 = daily, 1 = weekly, 2 = monthly
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.frequency,
    required this.completedDates,
  });

  Habit copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    int? frequency,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  bool isCompletedOn(DateTime date) {
    return completedDates.any((d) =>
    d.year == date.year && d.month == date.month && d.day == date.day
    );
  }

  int getStreak(DateTime currentDate) {
    int streak = 0;
    DateTime checkDate = currentDate;

    while (true) {
      if (isCompletedOn(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  double getCompletionPercentage(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int completed = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      if (isCompletedOn(date)) {
        completed++;
      }
    }
    return completed / daysInMonth;
  }
}

class MockData {
  static List<Habit> getMockHabits() {
    final now = DateTime.now();
    final completedDates = [
      now.subtract(const Duration(days: 1)),
      now.subtract(const Duration(days: 2)),
      now.subtract(const Duration(days: 3)),
    ];

    return [
      Habit(
        id: '1',
        name: 'Méditation',
        icon: Icons.self_improvement,
        color: const Color(0xFF6366F1),
        frequency: 0,
        completedDates: completedDates,
      ),
      Habit(
        id: '2',
        name: 'Sport',
        icon: Icons.fitness_center,
        color: const Color(0xFF10B981),
        frequency: 0,
        completedDates: [now.subtract(const Duration(days: 1))],
      ),
      Habit(
        id: '3',
        name: 'Lecture',
        icon: Icons.menu_book,
        color: const Color(0xFFF59E0B),
        frequency: 0,
        completedDates: [now.subtract(const Duration(days: 2))],
      ),
      Habit(
        id: '4',
        name: 'Eau (2L)',
        icon: Icons.water_drop,
        color: const Color(0xFF3B82F6),
        frequency: 0,
        completedDates: [now],
      ),
    ];
  }

  static int getTotalCompletedToday(List<Habit> habits) {
    final now = DateTime.now();
    return habits.where((h) => h.isCompletedOn(now)).length;
  }

  static int getBestStreak(List<Habit> habits, DateTime currentDate) {
    int maxStreak = 0;
    for (var habit in habits) {
      maxStreak = maxStreak > habit.getStreak(currentDate) ? maxStreak : habit.getStreak(currentDate);
    }
    return maxStreak;
  }

  static double getGlobalProgress(List<Habit> habits, DateTime currentDate) {
    if (habits.isEmpty) return 0;
    final completed = habits.where((h) => h.isCompletedOn(currentDate)).length;
    return completed / habits.length;
  }
}