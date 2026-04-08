// lib/screens/habits_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';  // ✅ À AJOUTER
import '../models/habit.dart';
import '../widgets/habit_card.dart';
import '../theme/app_theme.dart';  // ✅ À AJOUTER
import 'create_habit_screen.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    habits = MockData.getMockHabits();
  }

  void _toggleHabit(Habit habit, bool isChecked) {
    setState(() {
      final now = DateTime.now();
      if (isChecked) {
        if (!habit.isCompletedOn(now)) {
          final newCompletedDates = List<DateTime>.from(habit.completedDates)..add(now);
          final index = habits.indexWhere((h) => h.id == habit.id);
          habits[index] = habit.copyWith(completedDates: newCompletedDates);
        }
      } else {
        final newCompletedDates = habit.completedDates
            .where((d) => !(d.year == now.year && d.month == now.month && d.day == now.day))
            .toList();
        final index = habits.indexWhere((h) => h.id == habit.id);
        habits[index] = habit.copyWith(completedDates: newCompletedDates);
      }
    });
  }

  void _addHabit(Habit newHabit) {
    setState(() {
      habits.add(newHabit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedToday = habits.where((h) => h.isCompletedOn(DateTime.now())).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes habitudes',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completedToday/${habits.length} complétées',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            ),
          ),
          if (habits.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checklist_outlined,
                      size: 80,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune habitude',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Créez votre première habitude\npour commencer votre voyage',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateHabitScreen()),
                        );
                        if (result != null && result is Habit) {
                          _addHabit(result);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Créer une habitude'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return FadeInUp(
                      from: 20,
                      duration: const Duration(milliseconds: 500),
                      delay: Duration(milliseconds: index * 100),
                      child: HabitCard(
                        habit: habits[index],
                        onToggle: (isChecked) => _toggleHabit(habits[index], isChecked),
                      ),
                    );
                  },
                  childCount: habits.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FadeInUp(
        from: 50,
        duration: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateHabitScreen()),
            );
            if (result != null && result is Habit) {
              _addHabit(result);
            }
          },
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}