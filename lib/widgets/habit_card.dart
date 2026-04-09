// lib/widgets/habit_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // ✅ À AJOUTER
import '../models/habit.dart';
import '../theme/app_theme.dart';  // ✅ À AJOUTER

class HabitCard extends StatefulWidget {
  final Habit habit;
  final Function(bool) onToggle;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.habit.isCompletedOn(DateTime.now());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isCompleted = !_isCompleted;
              widget.onToggle(_isCompleted);
              if (_isCompleted) {
                _animationController.forward();
                Future.delayed(const Duration(milliseconds: 300), () {
                  _animationController.reverse();
                });
              }
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.habit.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.habit.icon,
                    color: widget.habit.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.habit.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          decoration: _isCompleted ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: Colors.orange.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Streak: ${widget.habit.getStreak(DateTime.now())} jours',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ScaleTransition(
                  scale: _animationController,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isCompleted
                          ? widget.habit.color
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: Icon(
                      _isCompleted ? Icons.check : Icons.check_circle_outline,
                      color: _isCompleted ? Colors.white : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}