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

/// Define un umbral y mensaje para advertencias de composición
class CompositionWarning {
  final String key;
  final String message;
  final IconData icon;
  final Color color;
  final int threshold;
  final int count;

  const CompositionWarning({
    required this.key,
    required this.message,
    required this.icon,
    required this.color,
    required this.threshold,
    required this.count,
  });
}

/// Recomendación estratégica para contrarrestar una advertencia de composición
class StrategicRecommendation {
  final String championName;
  final String reason;
  final String warningKey;
  final IconData icon;
  final Color color;

  const StrategicRecommendation({
    required this.championName,
    required this.reason,
    required this.warningKey,
    required this.icon,
    required this.color,
  });
}

/// Clase auxiliar para definir reglas de advertencia
class _WarningRule {
  final String key;
  final int threshold;
  final String message;
  final IconData icon;
  final Color color;

  const _WarningRule({
    required this.key,
    required this.threshold,
    required this.message,
    required this.icon,
    required this.color,
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

  // Atributos avanzados que no están en allDefinitions pero existen en Champion
  static final List<AttributeDef> _advancedDefinitions = [
    AttributeDef(
      key: 'Dash',
      label: 'Dash',
      icon: Icons.directions_run,
      color: Colors.pinkAccent,
      predicate: _hasDash,
    ),
    AttributeDef(
      key: 'Early Game',
      label: 'Early Game',
      icon: Icons.access_time,
      color: Colors.lightGreen,
      predicate: _isEarlyGame,
    ),
    AttributeDef(
      key: 'Mid Game',
      label: 'Mid Game',
      icon: Icons.timeline,
      color: Colors.orangeAccent,
      predicate: _isMidGame,
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
  static bool _hasDash(Champion c) => c.hasDash;
  static bool _isEarlyGame(Champion c) => c.isEarlyGame;
  static bool _isMidGame(Champion c) => c.isMidGame;

  /// Analiza un equipo y devuelve el conteo de cada atributo
  Map<String, int> analyze(List<Champion> team) {
    final result = <String, int>{};
    for (final def in allDefinitions) {
      result[def.key] = team.where(def.predicate).length;
    }
    // También contar atributos avanzados
    for (final def in _advancedDefinitions) {
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

  /// Genera advertencias automáticas sobre la composición enemiga
  /// Basado en umbrales y atributos estratégicos
  List<CompositionWarning> getCompositionWarnings(List<Champion> enemies) {
    if (enemies.isEmpty) return [];

    final warnings = <CompositionWarning>[];

    // Analizar usando los predicates existentes
    final Map<String, int> counts = {};
    for (final def in [...allDefinitions, ..._advancedDefinitions]) {
      counts[def.key] = enemies.where(def.predicate).length;
    }

    // Reglas de advertencia
    final rules = [
      _WarningRule(key: 'AD', threshold: 3, message: 'Mucho daño físico', icon: Icons.gps_fixed, color: AppColors.enemyRed),
      _WarningRule(key: 'AP', threshold: 3, message: 'Mucho daño mágico', icon: Icons.auto_awesome, color: Colors.purpleAccent),
      _WarningRule(key: 'Tanques', threshold: 2, message: 'Muchos tanques', icon: Icons.shield, color: Colors.blueGrey),
      _WarningRule(key: 'CC', threshold: 3, message: 'Mucho control de masas', icon: Icons.link, color: Colors.orange),
      _WarningRule(key: 'Dash', threshold: 3, message: 'Muchos Desplazamientos', icon: Icons.directions_run, color: Colors.pinkAccent),
      _WarningRule(key: 'AutoAtaques', threshold: 3, message: 'Muchos autoataques', icon: Icons.touch_app, color: Colors.amber),
      _WarningRule(key: 'Curas', threshold: 2, message: 'Mucha curación', icon: Icons.healing, color: Colors.greenAccent),
      _WarningRule(key: 'Escudos', threshold: 2, message: 'Muchos escudos', icon: Icons.health_and_safety, color: Colors.cyan),
      _WarningRule(key: 'Early Game', threshold: 3, message: 'Composición fuerte en early', icon: Icons.access_time, color: Colors.lightGreen),
      _WarningRule(key: 'Late Game', threshold: 3, message: 'Escala muy bien a late game', icon: Icons.trending_up, color: Colors.deepPurpleAccent),
    ];

    // Aplicar reglas
    for (final rule in rules) {
      final count = counts[rule.key] ?? 0;
      if (count >= rule.threshold) {
        warnings.add(CompositionWarning(
          key: rule.key,
          message: rule.message,
          icon: rule.icon,
          color: rule.color,
          threshold: rule.threshold,
          count: count,
        ));
      }
    }

    return warnings;
  }

  /// Genera recomendaciones estratégicas basadas en las advertencias de composición
  /// Devuelve campeones que contrarrestan las amenazas detectadas
  List<StrategicRecommendation> getStrategicRecommendations(
    List<CompositionWarning> warnings,
    String selectedRole,
    List<Champion> allChampions,
  ) {
    if (warnings.isEmpty) return [];

    final recommendations = <StrategicRecommendation>[];
    // Filtrar campeones que pertenezcan al rol seleccionado
    final roleChampions = allChampions
        .where((c) => c.roles.contains(selectedRole))
        .toList();

    for (final warning in warnings) {
      final predefined = _getPredefinedCounters(warning.key);
      // Filtrar los predefinidos que estén en el rol
      final validPredefined = <StrategicRecommendation>[];
      for (final rec in predefined) {
        if (roleChampions.any((c) => c.name == rec.championName)) {
          validPredefined.add(rec);
        }
      }

      if (validPredefined.isNotEmpty) {
        recommendations.addAll(validPredefined);
      } else {
        // Buscar contadores según atributos
        final fallback = _findBestCounters(warning.key, roleChampions);
        recommendations.addAll(fallback);
      }
    }

    return recommendations;
  }

  // Métodos privados dentro de la clase

  /// Lista predefinida de contadores por clave de advertencia
  List<StrategicRecommendation> _getPredefinedCounters(String warningKey) {
    switch (warningKey) {
      case 'AD':
        return [
          StrategicRecommendation(
            championName: 'Rammus',
            reason: 'Rammus tiene armadura pasiva que refleja daño físico y su W aumenta su armadura masivamente',
            warningKey: warningKey,
            icon: Icons.gps_fixed,
            color: AppColors.enemyRed,
          ),
          StrategicRecommendation(
            championName: 'Malphite',
            reason: 'Malphite escala con armadura, su pasiva le da un escudo basado en armadura y su E reduce velocidad de ataque',
            warningKey: warningKey,
            icon: Icons.gps_fixed,
            color: AppColors.enemyRed,
          ),
        ];
      case 'AP':
        return [
          StrategicRecommendation(
            championName: 'Kassadin',
            reason: 'Kassadin tiene resistencia mágica pasiva que reduce el daño mágico recibido en un 15%',
            warningKey: warningKey,
            icon: Icons.auto_awesome,
            color: Colors.purpleAccent,
          ),
          StrategicRecommendation(
            championName: 'Galio',
            reason: 'Galio es un tanque mágico natural con alta resistencia mágica base y W que reduce daño mágico',
            warningKey: warningKey,
            icon: Icons.auto_awesome,
            color: Colors.purpleAccent,
          ),
        ];
      case 'Tanques':
        return [
          StrategicRecommendation(
            championName: 'Vayne',
            reason: 'Vayne tiene daño verdadero con su W que ignora la armadura de los tanques',
            warningKey: warningKey,
            icon: Icons.shield,
            color: Colors.blueGrey,
          ),
          StrategicRecommendation(
            championName: 'Fiora',
            reason: 'Fiora tiene daño verdadero con su pasiva y su ultimate que ignora defensas',
            warningKey: warningKey,
            icon: Icons.shield,
            color: Colors.blueGrey,
          ),
        ];
      case 'CC':
        return [
          StrategicRecommendation(
            championName: 'Olaf',
            reason: 'Olaf con su ultimate Ragnarok se vuelve inmune a todo control de masas durante 6 segundos',
            warningKey: warningKey,
            icon: Icons.link,
            color: Colors.orange,
          ),
          StrategicRecommendation(
            championName: 'Morgana',
            reason: 'Morgana tiene un escudo mágico (E) que bloquea todo control de masas',
            warningKey: warningKey,
            icon: Icons.link,
            color: Colors.orange,
          ),
        ];
      case 'Dash':
        return [
          StrategicRecommendation(
            championName: 'Lissandra',
            reason: 'Lissandra tiene root con su W y ultimate que inmoviliza en area, atrapando campeones móviles',
            warningKey: warningKey,
            icon: Icons.directions_run,
            color: Colors.pinkAccent,
          ),
          StrategicRecommendation(
            championName: 'Poppy', 
            reason: 'Poppy corta saltos y desplazamientos con su W', 
            warningKey: warningKey, 
            icon: Icons.block_flipped,
            color: Colors.indigo.shade400,
            )
        ];
      case 'AutoAtaques':
        return [
          StrategicRecommendation(
            championName: 'Shen',
            reason: 'Shen tiene W que crea una zona que esquiva todos los ataques básicos durante 1.75 segundos',
            warningKey: warningKey,
            icon: Icons.touch_app,
            color: Colors.amber,
          ),
          StrategicRecommendation(
            championName: 'Jax',
            reason: 'Jax tiene E que esquiva todos los ataques básicos y luego aturde en area',
            warningKey: warningKey,
            icon: Icons.touch_app,
            color: Colors.amber,
          ),
        ];
      case 'Curas':
        return [
          StrategicRecommendation(
            championName: 'Katarina',
            reason: 'Katarina aplica heridas graves con su ultimate que reduce la curación del enemigo en un 60%',
            warningKey: warningKey,
            icon: Icons.healing,
            color: Colors.greenAccent,
          ),
          StrategicRecommendation(
            championName: 'Miss Fortune',
            reason: 'Miss Fortune aplica heridas graves con su E, reduciendo la curación enemiga',
            warningKey: warningKey,
            icon: Icons.healing,
            color: Colors.greenAccent,
          ),
        ];
      case 'Escudos':
        return [
          StrategicRecommendation(
            championName: 'Blitzcrank',
            reason: 'Blitzcrank tiene Q que ignora escudos al agarrar al objetivo directamente',
            warningKey: warningKey,
            icon: Icons.health_and_safety,
            color: Colors.cyan,
          ),
          StrategicRecommendation(
            championName: 'Renekton',
            reason: 'Renekton con su W potenciado rompe escudos y aturde al objetivo',
            warningKey: warningKey,
            icon: Icons.health_and_safety,
            color: Colors.cyan,
          ),
        ];
      case 'Early Game':
        return [
          StrategicRecommendation(
            championName: 'Kog\'Maw',
            reason: 'Kog\'Maw escala muy bien a late game, convirtiéndose en un hiper carry imparable',
            warningKey: warningKey,
            icon: Icons.access_time,
            color: Colors.lightGreen,
          ),
          StrategicRecommendation(
            championName: 'Kayle',
            reason: 'Kayle escala a nivel 16 volviéndose inmortal y con daño en area masivo',
            warningKey: warningKey,
            icon: Icons.access_time,
            color: Colors.lightGreen,
          ),
        ];
      case 'Late Game':
        return [
          StrategicRecommendation(
            championName: 'Pantheon',
            reason: 'Pantheon domina early game con su pasiva y puede cerrar partidas antes del late',
            warningKey: warningKey,
            icon: Icons.trending_up,
            color: Colors.deepPurpleAccent,
          ),
          StrategicRecommendation(
            championName: 'Draven',
            reason: 'Draven presiona fuerte en early y puede ganar linea para acelerar la partida',
            warningKey: warningKey,
            icon: Icons.trending_up,
            color: Colors.deepPurpleAccent,
          ),
          StrategicRecommendation(
            championName: 'Lee Sin', 
            reason: 'Lee Sin domina el early y puedes ganar antes de llegar al late.', 
            warningKey: warningKey, 
            icon: Icons.directions_run, 
            color: Colors.orange.shade700
            ),
        ];
      default:
        return [];
    }
  }

  /// Encuentra los mejores contadores en el rol dado usando atributos
  List<StrategicRecommendation> _findBestCounters(String warningKey, List<Champion> roleChampions) {
    final candidates = <Champion>[];
    switch (warningKey) {
      case 'AD':
        candidates.addAll(roleChampions.where((c) => c.isTank || c.hasShield));
        break;
      case 'AP':
        candidates.addAll(roleChampions.where((c) => c.isTank && (c.hasShield || c.hasHealing)));
        break;
      case 'Tanques':
        candidates.addAll(roleChampions.where((c) => c.isAD && c.usesAutoAttacks || c.isMelee));
        break;
      case 'CC':
        candidates.addAll(roleChampions.where((c) => c.hasEngage || c.hasShield || c.isTank));
        break;
      case 'Dash':
        candidates.addAll(roleChampions.where((c) => c.hasCC));
        break;
      case 'AutoAtaques':
        candidates.addAll(roleChampions.where((c) => c.hasShield || c.isTank));
        break;
      case 'Curas':
        candidates.addAll(roleChampions.where((c) => c.isAD || c.isAP));
        break;
      case 'Escudos':
        candidates.addAll(roleChampions.where((c) => c.hasCC || c.hasEngage));
        break;
      case 'Early Game':
        candidates.addAll(roleChampions.where((c) => c.scalesLateGame));
        break;
      case 'Late Game':
        candidates.addAll(roleChampions.where((c) => c.isEarlyGame));
        break;
      default:
        break;
    }

    if (candidates.isEmpty) return [];

    final unique = candidates.toSet().take(2).toList();
    return unique.map((c) {
      String reason;
      IconData icon;
      Color color;
      switch (warningKey) {
        case 'AD':
          reason = '${c.name} es resistente al daño físico';
          icon = Icons.gps_fixed;
          color = AppColors.enemyRed;
          break;
        case 'AP':
          reason = '${c.name} tiene resistencia mágica';
          icon = Icons.auto_awesome;
          color = Colors.purpleAccent;
          break;
        case 'Tanques':
          reason = '${c.name} puede lidiar con tanques';
          icon = Icons.shield;
          color = Colors.blueGrey;
          break;
        case 'CC':
          reason = '${c.name} puede resistir o inmunizar control de masas';
          icon = Icons.link;
          color = Colors.orange;
          break;
        case 'Dash':
          reason = '${c.name} puede inmovilizar enemigos móviles';
          icon = Icons.directions_run;
          color = Colors.pinkAccent;
          break;
        case 'AutoAtaques':
          reason = '${c.name} puede bloquear ataques básicos';
          icon = Icons.touch_app;
          color = Colors.amber;
          break;
        case 'Curas':
          reason = '${c.name} puede aplicar presión sostenida';
          icon = Icons.healing;
          color = Colors.greenAccent;
          break;
        case 'Escudos':
          reason = '${c.name} puede romper escudos';
          icon = Icons.health_and_safety;
          color = Colors.cyan;
          break;
        case 'Early Game':
          reason = '${c.name} escala bien a late game';
          icon = Icons.access_time;
          color = Colors.lightGreen;
          break;
        case 'Late Game':
          reason = '${c.name} es fuerte en early game';
          icon = Icons.trending_up;
          color = Colors.deepPurpleAccent;
          break;
        default:
          reason = '${c.name} puede contrarrestar esta amenaza';
          icon = Icons.star;
          color = AppColors.textPrimary;
      }
      return StrategicRecommendation(
        championName: c.name,
        reason: reason,
        warningKey: warningKey,
        icon: icon,
        color: color,
      );
    }).toList();
  }
}