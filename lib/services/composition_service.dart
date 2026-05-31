// SERVICIO: Centraliza toda la lógica de análisis de composición de equipos
// Define atributos, sus íconos, colores y cómo contarlos

import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../theme/app_colors.dart';

/// Definición de un atributo de composición
class AttributeDef {
  final String key;
  final String label;
  final IconData icon;
  final Color color;
  final bool Function(Champion) predicate;

  const AttributeDef({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.predicate,
  });
}

class CompositionService {
  /// Lista completa de definiciones de atributos (orden controlado)
  static const List<AttributeDef> allDefinitions = [
    AttributeDef(
      key: 'AD',
      label: 'AD',
      icon: Icons.gps_fixed,
      color: AppColors.enemyRed,
      predicate: _isAD,
    ),
    AttributeDef(
      key: 'AP',
      label: 'AP',
      icon: Icons.auto_awesome,
      color: Colors.purpleAccent,
      predicate: _isAP,
    ),
    AttributeDef(
      key: 'Tanques',
      label: 'Tanques',
      icon: Icons.shield,
      color: Colors.blueGrey,
      predicate: _isTank,
    ),
    AttributeDef(
      key: 'CC',
      label: 'CC',
      icon: Icons.link,
      color: Colors.orange,
      predicate: _hasCC,
    ),
    AttributeDef(
      key: 'Iniciadores',
      label: 'Iniciadores',
      icon: Icons.flash_on,
      color: Colors.yellowAccent,
      predicate: _hasEngage,
    ),
    AttributeDef(
      key: 'Curas',
      label: 'Curas',
      icon: Icons.healing,
      color: Colors.greenAccent,
      predicate: _hasHealing,
    ),
    AttributeDef(
      key: 'Escudos',
      label: 'Escudos',
      icon: Icons.health_and_safety,
      color: Colors.cyan,
      predicate: _hasShield,
    ),
    AttributeDef(
      key: 'AutoAtaques',
      label: 'AutoAtaques',
      icon: Icons.touch_app,
      color: Colors.amber,
      predicate: _usesAutoAttacks,
    ),
    AttributeDef(
      key: 'Melee',
      label: 'Melee',
      icon: Icons.front_hand,
      color: Colors.deepOrangeAccent,
      predicate: _isMelee,
    ),
    AttributeDef(
      key: 'Late Game',
      label: 'Late Game',
      icon: Icons.trending_up,
      color: Colors.deepPurpleAccent,
      predicate: _scalesLateGame,
    ),
  ];

  // Funciones auxiliares estáticas para los predicates
  static bool _isAD(Champion c) => c.isAD;
  static bool _isAP(Champion c) => c.isAP;
  static bool _isTank(Champion c) => c.isTank;
  static bool _hasCC(Champion c) => c.hasCC;
  static bool _hasEngage(Champion c) => c.hasEngage;
  static bool _hasHealing(Champion c) => c.hasHealing;
  static bool _hasShield(Champion c) => c.hasShield;
  static bool _usesAutoAttacks(Champion c) => c.usesAutoAttacks;
  static bool _isMelee(Champion c) => c.isMelee;
  static bool _scalesLateGame(Champion c) => c.scalesLateGame;

  /// Analiza un equipo y devuelve el conteo de cada atributo
  Map<String, int> analyze(List<Champion> team) {
    final result = <String, int>{};
    for (final def in allDefinitions) {
      result[def.key] = team.where(def.predicate).length;
    }
    return result;
  }

  /// Obtiene las definiciones de atributos a mostrar según el contexto
  /// [extended]: true para enemigos (6 atributos), false para aliados (4 atributos)
  List<AttributeDef> getDefinitionsForDisplay({required bool extended}) {
    final keysToShow = extended
        ? ['AD', 'AP', 'Tanques', 'CC', 'Iniciadores', 'Curas']
        : ['AD', 'AP', 'Tanques', 'CC'];

    return allDefinitions.where((def) => keysToShow.contains(def.key)).toList();
  }
}