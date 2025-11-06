import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool isEnabled;
  final List<Color>? gradientColors;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 56,
    this.isEnabled = true,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [
      const Color(0xFFB037F5),
      const Color(0xFF3C78FF),
    ];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEnabled ? colors : [
            Colors.grey.shade600,
            Colors.grey.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: colors[0].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: colors[1].withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isEnabled ? onPressed : null,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isEnabled ? Colors.white : Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}