import 'package:flutter/material.dart';

class AppColors {
  // Fondos
  static const Color backgroundDark = Color(0xFF0A0E17);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF1E2430);

  // Equipos
  static const Color allyBlue = Color(0xFF3B82F6);
  static const Color allyBlueGlow = Color(0xFF1E3A5F);
  static const Color enemyRed = Color(0xFFEF4444);
  static const Color enemyRedGlow = Color(0xFF5F1E1E);

  // Acentos
  static const Color accentGold = Color(0xFFF0B90B);
  static const Color accentGoldLight = Color(0xFFFDE68A);

  // Texto
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Bordes
  static const Color borderDark = Color(0xFF2D3548);
  static const Color borderGlow = Color(0xFF3B4A6B);

  // Roles
  static const Color topOrange = Color(0xFFF97316);
  static const Color jgGreen = Color(0xFF22C55E);
  static const Color midPurple = Color(0xFFA855F7);
  static const Color adcAmber = Color(0xFFF59E0B);
  static const Color suppTeal = Color(0xFF14B8A6);

  static Color getRoleColor(String role) {
    switch (role) {
      case 'TOP': return topOrange;
      case 'JG': return jgGreen;
      case 'MID': return midPurple;
      case 'ADC': return adcAmber;
      case 'SUPP': return suppTeal;
      default: return textMuted;
    }
  }

  // Modo activo (púrpura seleccionado)
  static const Color selectedPurple = Color(0xFF7C3AED);
  static const Color selectedPurpleGlow = Color(0xFF4C1D95);
}