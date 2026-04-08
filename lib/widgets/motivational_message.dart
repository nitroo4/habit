// lib/widgets/motivational_message.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class MotivationalMessage extends StatelessWidget {
  final double progress;

  const MotivationalMessage({
    super.key,
    required this.progress,
  });

  String _getMessage() {
    if (progress == 0) {
      return "✨ Commençons cette nouvelle journée du bon pied !";
    } else if (progress < 0.3) {
      return "💪 Un bon début ! Continuez sur cette lancée !";
    } else if (progress < 0.6) {
      return "🌟 Super progression ! Vous êtes sur la bonne voie !";
    } else if (progress < 0.9) {
      return "🎯 Presque là ! Encore un petit effort !";
    } else if (progress < 1) {
      return "🏆 Exceptionnel ! Terminez en beauté !";
    } else {
      return "🎉 Félicitations ! Journée parfaite ! Vous êtes incroyable !";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getMessage(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toInt()}% des habitudes complétées',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: progress == 1
                  ? const Icon(Icons.celebration, color: Colors.white, size: 30)
                  : const Icon(Icons.emoji_events, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}