import 'package:flutter/material.dart';

class AppColors {
  // Legacy colors (kept for existing screens)
  static const Color primaryColor = Colors.redAccent;
  static const Color secondaryColor = Color(0xFF2E2E2E);
  static const Color tertiaryColor = Color(0xFF3E3E3E);

  // Airline Booking Theme
  static const Color airBlue = Color(0xFF1A1F4B); // Deep navy
  static const Color airBlueMid = Color(0xFF2D3480); // Rich indigo
  static const Color airAccent = Color(0xFF4FC3F7); // Sky blue accent
  static const Color airGold = Color(0xFFFFD54F); // Premium gold
  static const Color airWhite = Color(0xFFF8F9FF); // Soft white
  static const Color airSurface = Color(0xFF0F1135); // Dark bg
  static const Color airCard = Color(0xFF1E2351); // Card bg
  static const Color airSuccess = Color(0xFF00E5A0); // Success teal
  static const Color airPink = Color(0xFFE040FB); // Accent purple

  // Gradient presets
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F1135), Color(0xFF1A1F4B), Color(0xFF2D3480)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E2351), Color(0xFF161A3D)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF4FC3F7), Color(0xFF4A80F5)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)],
  );
}
