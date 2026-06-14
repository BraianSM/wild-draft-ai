// SERVICIO: Centraliza toda la lógica de análisis de composición de equipos
// Define atributos, sus íconos, colores y cómo contarlos

import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../theme/app_colors.dart';
import 'package:flutter/foundation.dart';

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

/// Insight estratégico sobre la composición enemiga
class StrategicInsight {
  final String type;
  final String description;
  final IconData icon;
  final Color color;
  final double intensity;

  const StrategicInsight({
    required this.type,
    required this.description,
    required this.icon,
    required this.color,
    this.intensity = 0.0,
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
      key: 'Tank',
      label: 'Tank',
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
      key: 'Engages',
      label: 'Engages',
      icon: Icons.flash_on,
      color: Colors.yellowAccent,
      predicate: _hasEngage,
    ),
    AttributeDef(
      key: 'Heal',
      label: 'Heal',
      icon: Icons.healing,
      color: Colors.greenAccent,
      predicate: _hasHealing,
    ),
    AttributeDef(
      key: 'Shield',
      label: 'Shield',
      icon: Icons.health_and_safety,
      color: Colors.cyan,
      predicate: _hasShield,
    ),
    AttributeDef(
      key: 'AutoAttacks',
      label: 'AutoAttacks',
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
    for (final def in _advancedDefinitions) {
      result[def.key] = team.where(def.predicate).length;
    }
    return result;
  }

  /// Obtiene las definiciones de atributos a mostrar según el contexto
  List<AttributeDef> getDefinitionsForDisplay({required bool extended}) {
    final keysToShow = extended
        ? ['AD', 'AP', 'Tank', 'CC', 'Engages', 'Heal']
        : ['AD', 'AP', 'Tank', 'CC'];
    return allDefinitions.where((def) => keysToShow.contains(def.key)).toList();
  }

  /// Verifica si un campeón tiene un strategic tag específico
  bool championHasTag(Champion champion, String tag) {
    return champion.strategicTags.contains(tag);
  }

  /// Filtra campeones que posean un strategic tag determinado
  List<Champion> getChampionsWithTag(String tag, List<Champion> champions) {
    return champions.where((c) => championHasTag(c, tag)).toList();
  }

  /// Genera advertencias automáticas sobre la composición enemiga
  List<CompositionWarning> getCompositionWarnings(List<Champion> enemies) {
    if (enemies.isEmpty) return [];

    final warnings = <CompositionWarning>[];
    final Map<String, int> counts = {};
    for (final def in [...allDefinitions, ..._advancedDefinitions]) {
      counts[def.key] = enemies.where(def.predicate).length;
    }

    final rules = [
      _WarningRule(key: 'AD', threshold: 3, message: 'Mucho daño físico', icon: Icons.gps_fixed, color: AppColors.enemyRed),
      _WarningRule(key: 'AP', threshold: 3, message: 'Mucho daño mágico', icon: Icons.auto_awesome, color: Colors.purpleAccent),
      _WarningRule(key: 'Tank', threshold: 2, message: 'Muchos tanques', icon: Icons.shield, color: Colors.blueGrey),
      _WarningRule(key: 'CC', threshold: 3, message: 'Mucho control de masas', icon: Icons.link, color: Colors.orange),
      _WarningRule(key: 'Dash', threshold: 3, message: 'Muchos Desplazamientos', icon: Icons.directions_run, color: Colors.pinkAccent),
      _WarningRule(key: 'AutoAttacks', threshold: 3, message: 'Muchos autoataques', icon: Icons.touch_app, color: Colors.amber),
      _WarningRule(key: 'Heal', threshold: 3, message: 'Mucha curación', icon: Icons.healing, color: Colors.greenAccent),
      _WarningRule(key: 'Shield', threshold: 3, message: 'Muchos escudos', icon: Icons.health_and_safety, color: Colors.cyan),
      _WarningRule(key: 'Early Game', threshold: 3, message: 'Composición fuerte en early', icon: Icons.access_time, color: Colors.lightGreen),
      _WarningRule(key: 'Late Game', threshold: 3, message: 'Escala muy bien a late game', icon: Icons.trending_up, color: Colors.deepPurpleAccent),
    ];

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

  /// FASE 1: Analiza la composición enemiga completa y genera insights estratégicos
  List<StrategicInsight> generateStrategicInsights(List<Champion> enemies) {
    if (enemies.isEmpty) return [];

    final counts = analyze(enemies);
    final teamSize = enemies.length;
    final insights = <StrategicInsight>[];
    final frontline = enemies.where((c) => championHasTag(c, 'frontline')).length;

    // Frontline
    final frontlineRatio = frontline / teamSize;
    if (frontlineRatio >= 0.4 && frontline >= 2 && teamSize >= 4) {
    insights.add(
    StrategicInsight(
      type: 'heavy_frontline',
      description: 'El enemigo posee una línea frontal muy sólida.',
      icon: Icons.shield,
      color: Colors.blueGrey,
      intensity: frontlineRatio,
    ),
  );
}
    // Composicion de Frontline 
    if (frontline == 0 && teamSize >= 4 && teamSize >= 3) {
    insights.add(const StrategicInsight(
    type: 'no_frontline',
    description: 'El enemigo carece de una línea frontal sólida.',
    icon: Icons.shield,
    color: Colors.blueGrey,
  ));
}
    // Frontline débil
    if (frontline == 1 && teamSize >= 4) {
    insights.add(const StrategicInsight(
    type: 'weak_frontline',
    description: 'El enemigo tiene una línea frontal limitada.',
    icon: Icons.shield,
    color: Colors.blueGrey,
  ));
}

    // Mucho daño físico
    final adCount = counts['AD'] ?? 0;
    final adRatio = adCount / teamSize;
    if (adRatio >= 0.7 && adCount >= 2) {
      insights.add(StrategicInsight(
        type: 'heavy_ad',
        description: 'La composición enemiga depende principalmente de daño físico.',
        icon: Icons.gps_fixed,
        color: AppColors.enemyRed,
        intensity: adRatio,
      ));
    }

    // Mucho daño mágico
    final apCount = counts['AP'] ?? 0;
    final apRatio = apCount / teamSize;
    if (apRatio >= 0.7 && apCount >= 2) {
      insights.add(StrategicInsight(
        type: 'heavy_ap',
        description: 'El enemigo tiene una fuerte fuente de daño mágico.',
        icon: Icons.auto_awesome,
        color: Colors.purpleAccent,
        intensity: apRatio,
      ));
    }

    // Composición con múltiples AP carries
      final apCarryCount = enemies.where((c) =>
      (c.roles.contains('MID') || c.roles.contains('ADC')) && c.isAP).length;
      if (apCarryCount >= 2) {
      insights.add(StrategicInsight(
        type: 'heavy_ap_carries',
        description: 'El enemigo tiene múltiples carries de daño mágico.',
        icon: Icons.auto_awesome,
        color: Colors.purpleAccent,
        intensity: apCarryCount / teamSize,
      ));
    }
    
    // Muchos tanques
    final tankCount = counts['Tank'] ?? 0;
    final tankRatio = tankCount / teamSize;
    if (tankRatio >= 0.5 && tankCount >= 2 && teamSize >= 3) {
      insights.add(StrategicInsight(
        type: 'tanky',
        description: 'El enemigo tiene varios campeones resistentes.',
        icon: Icons.shield,
        color: Colors.blueGrey,
        intensity: tankRatio,
      ));
    }

    // Mucho CC
    final ccCount = counts['CC'] ?? 0;
    final ccRatio = ccCount / teamSize;
    if (ccRatio >= 0.5 && ccCount >= 2) {
      insights.add(StrategicInsight(
        type: 'heavy_cc',
        description: 'El enemigo tiene gran capacidad para iniciar peleas y encadenar control.',
        icon: Icons.link,
        color: Colors.orange,
        intensity: ccRatio,
      ));
    }

    // Mucha movilidad
    final dashCount = counts['Dash'] ?? 0;
    final dashRatio = dashCount / teamSize;
    if (dashRatio >= 0.5 && dashCount >= 2) {
      insights.add(StrategicInsight(
        type: 'high_mobility',
        description: 'Los campeones enemigos tienen muchos desplazamientos o dash.',
        icon: Icons.directions_run,
        color: Colors.pinkAccent,
        intensity: dashRatio,
      ));
    }

    // Dependencia de autoataques
    if ((counts['AutoAttacks'] ?? 0) >= 3) {
      final aaRatio = (counts['AutoAttacks'] ?? 0) / teamSize;
      insights.add(StrategicInsight(
        type: 'autoattack_reliant',
        description: 'Los ataques básicos son una fuente principal de daño enemigo.',
        icon: Icons.touch_app,
        color: Colors.amber,
        intensity: aaRatio,
      ));
    }

    // Mucha curación
    final healCount = counts['Heal'] ?? 0;
    final healRatio = healCount / teamSize;
    if (healRatio >= 0.5 && healCount >= 2) {
      insights.add(StrategicInsight(
        type: 'healing',
        description: 'El enemigo cuenta con curación significativa.',
        icon: Icons.healing,
        color: Colors.greenAccent,
        intensity: healRatio,
      ));
    }

    // Muchos escudos
    final shieldCount = counts['Shield'] ?? 0;
    final shieldRatio = shieldCount / teamSize;
    if (shieldRatio >= 0.5 && shieldCount >= 2) {
      insights.add(StrategicInsight(
        type: 'shielding',
        description: 'El enemigo tiene múltiples escudos para protegerse.',
        icon: Icons.health_and_safety,
        color: Colors.cyan,
        intensity: shieldRatio,
      ));
    }

    // Composición early game
    final earlyCount = counts['Early Game'] ?? 0;
    final earlyRatio = earlyCount / teamSize;
    if (earlyRatio >= 0.5 && earlyCount >= 2) {
      insights.add(const StrategicInsight(
        type: 'early_game',
        description: 'El enemigo busca ganar temprano con campeones de early game.',
        icon: Icons.access_time,
        color: Colors.lightGreen,
      ));
    }

    // Composición late game
    final lateCount = counts['Late Game'] ?? 0;
    final lateRatio = lateCount / teamSize;
    if (lateRatio >= 0.5 && lateCount >= 2) {
      insights.add(const StrategicInsight(
        type: 'late_game',
        description: 'El enemigo escala muy bien a late game.',
        icon: Icons.trending_up,
        color: Colors.deepPurpleAccent,
      ));
    }

    // Daño mixto balanceado
    final totalap = counts['AP'] ?? 0;

    if (adCount >= 2 && totalap >= 2) {
      insights.add(const StrategicInsight(
        type: 'mixed_damage',
        description: 'El enemigo posee fuentes equilibradas de daño físico y mágico, dificultando la itemización defensiva.',
        icon: Icons.balance,
        color: Colors.tealAccent,
      ));
    }

     insights.addAll(
      generateCompositionArchetype(enemies, counts),
    );

    // Justo antes del return insights; en generateStrategicInsights
    final seenTypes = <String>{};
    insights.removeWhere((insight) {
      if (seenTypes.contains(insight.type)) return true;
      seenTypes.add(insight.type);
      return false;
    });

    return insights;
  }

  /// Puntúa un campeón contra los insights de la composición enemiga.
  int scoreChampionAgainstComposition(Champion champion, List<StrategicInsight> insights) {
     int score = 0;
    bool hasSafePick = championHasTag(champion, 'safe_pick');
    bool safePickBonusApplied = false;

    for (final insight in insights) {
      switch (insight.type) {

        // ============ ARQUETIPOS (peso dominante) ============
        case 'pickoff_comp':
          if (championHasTag(champion, 'anti_pickoff')) score += 15;
          if (championHasTag(champion, 'safe_pick')) score += 10;
          break;
        case 'front_to_back_comp':
          if (championHasTag(champion, 'backline_access')) score += 10;
          if (championHasTag(champion, 'anti_tank')) score += 10;
          break;
        case 'dive_comp':
          if (championHasTag(champion, 'anti_dive')) score += 15;
          if (championHasTag(champion, 'peel')) score += 10;
          break;
        case 'poke_comp':
          if (championHasTag(champion, 'anti_poke')) score += 15;
          if (champion.hasEngage) score += 12;
          if (championHasTag(champion, 'backline_access')) score += 10;
          break;
        case 'engage_comp':
          if (championHasTag(champion, 'anti_engage')) score += 15;
          if (championHasTag(champion, 'peel')) score += 10;
          if (championHasTag(champion, 'frontline')) score += 5;
          break;
        case 'teamfight_comp':
          if (championHasTag(champion, 'splitpush')) score += 15;
          if (championHasTag(champion, 'pickoff')) score += 8;
          break;

        // ============ INSIGNIAS CRÍTICAS (peso medio, factor hasta 1.5) ============
        case 'heavy_ad':
          final factor = insight.intensity >= 0.8 ? 1.5 : 1.0;
          if (championHasTag(champion, 'anti_ad')) score += (10 * factor).round();
          if (championHasTag(champion, 'anti_autoattack')) score += 5;
          if (championHasTag(champion, 'frontline')) score += 3;
          if (champion.isTank) score += 2;
          if (champion.hasShield) score += 2;
          break;
        case 'heavy_ap':
          final factor = insight.intensity >= 0.8 ? 1.5 : 1.0;
          if (championHasTag(champion, 'anti_ap')) score += (10 * factor).round();
          if (championHasTag(champion, 'frontline')) score += 5;
          if (championHasTag(champion, 'backline_access')) score += 5;
          if (champion.isTank) score += 2;
          if (champion.hasShield) score += 2;
          break;
        case 'heavy_ap_carries':
          final apCarryFactor = insight.intensity >= 0.4 ? 1.5 : 1.0; // 2+ carries en 5
          if (championHasTag(champion, 'anti_ap')) score += (12 * apCarryFactor).round();
          if (champion.isTank) score += 4;
          if (champion.hasShield) score += 4;
          break;
        case 'healing':
          final factor = insight.intensity >= 0.6 ? 1.5 : 1.0;
          if (championHasTag(champion, 'anti_heal')) score += (12 * factor).round();
          if (champion.hasCC) score += 5;
          if (championHasTag(champion, 'pickoff')) score += 5;
          break;
        case 'shielding':
          final factor = insight.intensity >= 0.6 ? 1.5 : 1.0;
          if (championHasTag(champion, 'anti_shield')) score += (8 * factor).round();
          if (championHasTag(champion, 'backline_access')) score += 5;
          if (championHasTag(champion, 'pickoff')) score += 5;
          if (championHasTag(champion, 'burst')) score += 5;
          if (champion.hasEngage) score += 3;
          break;

        // ============ INSIGNIAS SECUNDARIAS (peso bajo, sin factor) ============
        case 'heavy_cc':
          if (championHasTag(champion, 'anti_cc')) score += 6;
          if (champion.hasShield) score += 2;
          break;
        case 'high_mobility':
          if (championHasTag(champion, 'anti_mobility')) score += 8;
          if (champion.hasCC) score += 3;
          break;
        case 'autoattack_reliant':
          if (championHasTag(champion, 'anti_autoattack')) score += 8;
          if (champion.hasShield) score += 2;
          if (champion.isTank) score += 2;
          break;
        case 'heavy_frontline':
        case 'tanky':
          if (championHasTag(champion, 'anti_tank')) score += 8;
          if (championHasTag(champion, 'backline_access')) score += 5;
          break;
        case 'weak_frontline':
        case 'no_frontline':
          if (championHasTag(champion, 'backline_access')) score += 6;
          if (championHasTag(champion, 'pickoff')) score += 6;
          break;
        case 'early_game':
          if (champion.scalesLateGame) score += 5;
          if (championHasTag(champion, 'safe_pick')) score += 3;
          break;
        case 'late_game':
          if (championHasTag(champion, 'strong_early')) score += 4;
          if (champion.isEarlyGame) score += 5;
          break;
        case 'mixed_damage':
          if (championHasTag(champion, 'frontline')) score += 5;
          if (champion.isTank) score += 3;
          if (champion.hasShield) score += 2;
          break;
          }

      // ============ SAFE PICK BONUS (sin cambios) ============
      if (!safePickBonusApplied && hasSafePick) {
        int safePickScore = 0;
        if (championHasTag(champion, 'peel')) safePickScore += 2;
        if (championHasTag(champion, 'waveclear')) safePickScore += 2;
        if (championHasTag(champion, 'anti_engage')) safePickScore += 2;
        if (championHasTag(champion, 'anti_dive')) safePickScore += 2;
        // Ajuste contextual
        if (insight.type == 'engage_comp' && championHasTag(champion, 'anti_engage')) safePickScore += 2;
        if (insight.type == 'dive_comp' && championHasTag(champion, 'anti_dive')) safePickScore += 2;
        if (insight.type == 'poke_comp' && championHasTag(champion, 'waveclear')) safePickScore += 1;

        if (safePickScore >= 6) {
          score += 3;
          safePickBonusApplied = true;
        }
      }
    }
    return score;
  }
     /// Genera insights de arquetipos de composición usando tags estratégicos.
  List<StrategicInsight> generateCompositionArchetype(
    List<Champion> enemies,
    Map<String, int> counts,
  ) {
    final insights = <StrategicInsight>[];
    final engageCount = enemies.where((c) => c.hasEngage).length;
    final pokeCount = enemies.where((c) => championHasTag(c, 'poke')).length;
    final diveCount = enemies.where((c) => championHasTag(c, 'dive')).length;
    final pickoffCount = enemies.where((c) => championHasTag(c, 'pickoff')).length;
    final teamfightCount = enemies.where((c) => championHasTag(c, 'teamfight')).length;
    final frontlineCount = enemies.where((c) => championHasTag(c, 'frontline')).length;
    final peelCount = enemies.where((c) => championHasTag(c, 'peel')).length;
    final teamSize = enemies.length.clamp(1, 5);
    final frontlineRatio = frontlineCount / teamSize;
    final teamfightRatio = teamfightCount / teamSize;
    final engageRatio = engageCount / teamSize;
    final peelRatio = peelCount / teamSize;
    final diveRatio = diveCount / teamSize;
    final pokeRatio = pokeCount / teamSize;
  


    // engage_comp
    if (engageRatio >= 0.6 && teamSize >= 3) {
      insights.add(
    StrategicInsight(
      type: 'engage_comp',
      description: 'La composición enemiga puede forzar peleas constantemente.',
      icon: Icons.flash_on,
      color: Colors.orange,
      intensity: engageRatio,
    ),
  );
}
 
  // teamfight_comp
  if (teamfightRatio >= 0.6 && teamSize >= 3) {
    insights.add(
  StrategicInsight(
      type: 'teamfight_comp',
      description: 'La composición enemiga destaca en peleas grupales.',
      icon: Icons.groups,
      color: Colors.purple,
      intensity: teamfightRatio,
    ),
  );
}
    // poke_comp
    if (pokeRatio >= 0.5 && frontlineRatio <= 0.3 && teamSize >= 3) {
      insights.add(const StrategicInsight(
        type: 'poke_comp',
        description: 'Composición de poke con poca protección frontal.',
        icon: Icons.architecture,
        color: Colors.cyan,
      ));
    }
    // dive_comp
    if (diveRatio >= 0.5 && diveCount >= 2 && teamSize >= 3) {
      insights.add(const StrategicInsight(
        type: 'dive_comp',
        description: 'Composición de dive agresivo.',
        icon: Icons.flash_on,
        color: Colors.redAccent,
      ));
    }
    // pickoff_comp
    final pickoffRatio = pickoffCount / teamSize;
    if (pickoffRatio >= 0.5 && pickoffCount >= 2 && teamSize >= 3) {
      insights.add(const StrategicInsight(
        type: 'pickoff_comp',
        description: 'Composición orientada a pickoffs.',
        icon: Icons.gps_fixed,
        color: Colors.orangeAccent,
      ));
    }
    // front_to_back_comp
    if (frontlineRatio >= 0.4 && (teamfightRatio >= 0.4 || peelRatio >= 0.2) 
    && diveRatio < 0.4 &&teamSize >= 3) {
    insights.add(
    StrategicInsight(
      type: 'front_to_back_comp',
      description: 'Composición clásica front-to-back con línea frontal y teamfight.',
      icon: Icons.shield,
      color: Colors.blueGrey,
      intensity: frontlineRatio,
    ),
  );
}
    return insights;
  }

  /// FASE 3: Obtiene los mejores campeones para el rol contra la composición enemiga
  List<StrategicRecommendation> getBestRecommendations(
    List<StrategicInsight> insights,
    String selectedRole,
    List<Champion> allChampions,
    List<Champion> enemies,
  ) {
    // Filtrar campeones del rol
    final roleChampions = allChampions
        .where((c) => c.roles.contains(selectedRole))
        .toList();

    if (roleChampions.isEmpty) return [];

    // Puntuar cada campeón
final scored = <MapEntry<Champion, int>>[];

for (final champ in roleChampions) {
  final score = scoreChampionAgainstComposition(champ, insights);

  if (score > 0) {
    scored.add(MapEntry(champ, score));
  }
}

// Ordenar por puntuación descendente
scored.sort((a, b) => b.value.compareTo(a.value));

// Mostrar solo TOP 5 con perfiles
for (final entry in scored.take(10)) {
  final profile = _getChampionProfile(entry.key, insights);

  debugPrint(
    '${entry.key.name} -> $profile -> ${entry.value}',
  );
}

        // Aplicar diversidad: máximo 2 campeones por perfil si el score es >=30% mayor
    final seenProfiles = <String, int>{}; // perfil -> score del primero
    final profileCounts = <String, int>{}; // perfil -> cuántos aceptados
    final uniqueTop = <MapEntry<Champion, int>>[];

    for (final entry in scored) {
      final profile = _getChampionProfile(entry.key, insights);

      if (!seenProfiles.containsKey(profile)) {
        // Primer campeón de este perfil
        seenProfiles[profile] = entry.value;
        profileCounts[profile] = 1;
        uniqueTop.add(entry);
      } else if (profileCounts[profile]! < 2 &&
                 entry.value > seenProfiles[profile]! * 1.3) {
        // Segundo campeón del mismo perfil solo si es significativamente mejor
        profileCounts[profile] = profileCounts[profile]! + 1;
        uniqueTop.add(entry);
      }

      if (uniqueTop.length >= 4) break;
    }

    // Si no hay suficientes, tomar los siguientes aunque repitan perfil
    if (uniqueTop.length < 3) {
      for (final entry in scored) {
        if (!uniqueTop.contains(entry)) {
          uniqueTop.add(entry);
        }
        if (uniqueTop.length >= 3) break;
      }
    }

    final recommendations = <StrategicRecommendation>[];
    for (final entry in uniqueTop) {
      final champ = entry.key;
      final reason = generateRecommendationReason(champ, insights);
      recommendations.add(StrategicRecommendation(
        championName: champ.name,
        reason: reason,
        warningKey: 'composition',
        icon: Icons.psychology,
        color: AppColors.accentGold,
      ));
    }

    return recommendations;
  }
    /// Método unificado: recopila tags y atributos activados por un campeón
  /// contra una lista de insights. Evita duplicar el switch en 3 lugares.
  Map<String, List<String>> _collectActivatedTags(
    Champion champ,
    List<StrategicInsight> insights,
  ) {
    final tags = <String>{};
    final attrs = <String>{};

    for (final insight in insights) {
      switch (insight.type) {
        // ============ ARQUETIPOS ============
        case 'engage_comp':
          if (championHasTag(champ, 'anti_engage')) tags.add('anti_engage');
          if (championHasTag(champ, 'peel')) tags.add('peel');
          if (championHasTag(champ, 'frontline')) tags.add('frontline');
          break;

        case 'teamfight_comp':
          if (championHasTag(champ, 'splitpush')) tags.add('splitpush');
          if (championHasTag(champ, 'pickoff')) tags.add('pickoff');
          break;

        case 'poke_comp':
          if (championHasTag(champ, 'anti_poke')) tags.add('anti_poke');
          if (championHasTag(champ, 'anti_engage')) tags.add('anti_engage');
          if (championHasTag(champ, 'backline_access')) tags.add('backline_access');
          break;

        case 'dive_comp':
          if (championHasTag(champ, 'anti_dive')) tags.add('anti_dive');
          if (championHasTag(champ, 'anti_engage')) tags.add('anti_engage');
          if (championHasTag(champ, 'peel')) tags.add('peel');
          break;

        case 'pickoff_comp':
          if (championHasTag(champ, 'anti_pickoff')) tags.add('anti_pickoff');
          if (championHasTag(champ, 'safe_pick')) tags.add('safe_pick');
          break;

        case 'front_to_back_comp':
        case 'heavy_frontline':
        case 'tanky':
          if (championHasTag(champ, 'anti_tank')) tags.add('anti_tank');
          if (championHasTag(champ, 'backline_access')) tags.add('backline_access');
          break;

        case 'weak_frontline':
        case 'no_frontline':
          if (championHasTag(champ, 'backline_access')) tags.add('backline_access');
          if (championHasTag(champ, 'pickoff')) tags.add('pickoff');
          break;

        // ============ INSIGNIAS CRÍTICAS ============
        case 'heavy_ad':
          if (championHasTag(champ, 'anti_ad')) tags.add('anti_ad');
          if (championHasTag(champ, 'anti_autoattack')) tags.add('anti_autoattack');
          if (champ.isTank) attrs.add('tanque');
          break;

        case 'heavy_ap':
        case 'heavy_ap_carries':
          if (championHasTag(champ, 'anti_ap')) tags.add('anti_ap');
          if (champ.isTank) attrs.add('tanque');
          if (champ.hasShield) attrs.add('escudos');
          break;

        case 'healing':
          if (championHasTag(champ, 'anti_heal')) tags.add('anti_heal');
          if (championHasTag(champ, 'pickoff')) tags.add('pickoff');
          if (champ.hasCC) attrs.add('CC');
          break;

        case 'shielding':
          if (championHasTag(champ, 'anti_shield')) tags.add('anti_shield');
          if (championHasTag(champ, 'backline_access')) tags.add('backline_access');
          if (championHasTag(champ, 'pickoff')) tags.add('pickoff');
          if (championHasTag(champ, 'burst')) tags.add('burst');
          break;

        // ============ INSIGNIAS SECUNDARIAS ============
        case 'heavy_cc':
          if (championHasTag(champ, 'anti_cc')) tags.add('anti_cc');
          if (championHasTag(champ, 'safe_pick')) tags.add('safe_pick');
          if (championHasTag(champ, 'anti_engage')) tags.add('anti_engage');
          break;

        case 'high_mobility':
          if (championHasTag(champ, 'anti_mobility')) tags.add('anti_mobility');
          if (championHasTag(champ, 'safe_pick')) tags.add('safe_pick');
          if (champ.hasCC) attrs.add('CC');
          break;

        case 'autoattack_reliant':
          if (championHasTag(champ, 'anti_autoattack')) tags.add('anti_autoattack');
          if (champ.hasShield) attrs.add('escudos');
          break;

        case 'early_game':
          if (championHasTag(champ, 'scaling')) tags.add('scaling');
          if (champ.scalesLateGame) attrs.add('late game');
          break;

        case 'late_game':
          if (championHasTag(champ, 'strong_early')) tags.add('strong_early');
          if (champ.isEarlyGame) attrs.add('early game');
          break;

        case 'mixed_damage':
          if (championHasTag(champ, 'frontline')) tags.add('frontline');
          if (champ.isTank) attrs.add('tanque');
          if (champ.hasShield) attrs.add('escudos');
          break;
      }
    }

    return {
      'tags': tags.toList(),
      'attrs': attrs.toList(),
    };
  }

    /// Genera un perfil de tags activados para un campeón, para agrupar similares.
  String _getChampionProfile(Champion champ, List<StrategicInsight> insights) {
    final collected = _collectActivatedTags(champ, insights);
    final rawTags = collected['tags']!;

    // Traducción a versiones simplificadas para diversidad
    final simplified = rawTags.map((tag) {
      switch (tag) {
        case 'backline_access': return 'backline';
        case 'pickoff':        return 'pickoff';
        case 'anti_tank':      return 'anti_tank';
        case 'anti_ad':        return 'anti_ad';
        case 'anti_ap':        return 'anti_ap';
        case 'anti_cc':        return 'anti_cc';
        case 'anti_heal':      return 'anti_heal';
        case 'anti_shield':    return 'anti_shield';
        case 'anti_mobility':  return 'anti_mobility';
        case 'anti_autoattack':return 'anti_autoattack';
        case 'anti_poke':      return 'anti_poke';
        case 'anti_dive':      return 'anti_dive';
        case 'anti_pickoff':   return 'anti_pickoff';
        case 'anti_teamfight': return 'anti_teamfight';
        case 'anti_engage':    return 'anti_engage';
        case 'safe_pick':      return 'safe';
        case 'frontline':      return 'frontline';
        case 'strong_early':   return 'strong_early';
        case 'splitpush':      return 'splitpush';
        default:               return tag;
      }
    }).toList();

    simplified.sort();
    return simplified.join('|');
  }

    /// Genera una razón humana y estratégica para la recomendación.
  String generateRecommendationReason(Champion champ, List<StrategicInsight> insights) {
    final collected = _collectActivatedTags(champ, insights);
    final activatedTags = collected['tags']!;
    final activatedAttrs = collected['attrs']!;
    return _buildCoachingReason(champ, activatedTags, activatedAttrs);
  }
   /// Versión mejorada: explicación natural jerarquizada, sin "tag dumping".
  String _buildCoachingReason(
    Champion champ,
    List<String> tags,
    List<String> attrs,
  ) {
    // --- 1. Clasificación de conceptos ---
    final counters = <String>{};   // anti_* tags
    final utility = <String>{};    // otros tags de utilidad
    final traits = <String>{};     // atributos del campeón

    for (final t in tags) {
      if (t.startsWith('anti_')) {
        counters.add(t);
      } else {
        utility.add(t);
      }
    }
    traits.addAll(attrs);

    // --- 2. Mapeo a frases humanas ---
    String counterLabel(String tag) {
      switch (tag) {
        case 'anti_ad': return 'daño físico';
        case 'anti_ap': return 'daño mágico';
        case 'anti_tank': return 'tanques';
        case 'anti_autoattack': return 'ataques básicos';
        case 'anti_heal': return 'curación';
        case 'anti_shield': return 'escudos';
        case 'anti_cc': return 'control de masas';
        case 'anti_mobility': return 'movilidad enemiga';
        case 'anti_poke': return 'poke';
        case 'anti_dive': return 'dive';
        case 'anti_pickoff': return 'pickoffs';
        case 'anti_teamfight': return 'teamfights';
        case 'anti_engage': return 'iniciación enemiga';
        default: return '';
      }
    }

    String utilityLabel(String tag) {
      switch (tag) {
        case 'peel': return 'protege a tu equipo';
        case 'safe_pick': return 'es un pick seguro';
        case 'backline_access': return 'puede eliminar a los carries rivales';
        case 'frontline': return 'aporta solidez en la línea frontal';
        case 'splitpush': return 'presiona en líneas laterales';
        case 'pickoff': return 'busca y castiga enemigos aislados';
        case 'dive': return 'puede lanzarse sobre la backline';
        case 'strong_early': return 'domina la fase temprana';
        case 'waveclear': return 'limpia oleadas rápido';
        case 'burst': return 'tiene alto daño explosivo';
        default: return '';
      }
    }

    String traitLabel(String attr) {
      switch (attr) {
        case 'tanque': return 'muy resistente';
        case 'escudos': return 'con escudos para proteger aliados';
        case 'CC': return 'con control de masas';
        case 'late game': return 'fuerte en late game';
        case 'early game': return 'dominante en early game';
        default: return '';
      }
    }

    // --- 3. Filtramos conceptos no vacíos ---
    final counterPhrases = counters.map(counterLabel).where((e) => e.isNotEmpty).toList();
    final utilityPhrases = utility.map(utilityLabel).where((e) => e.isNotEmpty).toList();
    final traitPhrases = traits.map(traitLabel).where((e) => e.isNotEmpty).toList();

    // --- 4. Construcción de la frase final con jerarquía ---

    // Si no hay nada, fallback genérico
    if (counterPhrases.isEmpty && utilityPhrases.isEmpty && traitPhrases.isEmpty) {
      return '${champ.name} es una buena elección contra esta composición.';
    }

    // Variamos la apertura para que no sea siempre igual
    final openings = [
      '${champ.name} es una excelente elección porque contrarresta',
      '${champ.name} destaca aquí ya que frena',
      '${champ.name} encaja perfecto porque anula',
    ];
    final opening = openings[champ.name.hashCode.abs() % openings.length];

    final buffer = StringBuffer();

    // --- COUNTERS (lo más importante primero) ---
    if (counterPhrases.isNotEmpty) {
      buffer.write('$opening ${counterPhrases.join(', ')}');
      if (utilityPhrases.isNotEmpty || traitPhrases.isNotEmpty) {
        buffer.write('. ');
      } else {
        buffer.write('.');
      }
    }

    // --- UTILIDAD (medio) ---
    if (utilityPhrases.isNotEmpty) {
      if (counterPhrases.isEmpty) {
        buffer.write('${champ.name} es útil en esta partida: ${utilityPhrases.join(', ')}');
      } else {
        buffer.write('Además, ${utilityPhrases.join(', ')}');
      }
      if (traitPhrases.isNotEmpty) {
        buffer.write('. ');
      } else {
        buffer.write('.');
      }
    }

    // --- ATRIBUTOS (último, como bonus) ---
    if (traitPhrases.isNotEmpty) {
      if (counterPhrases.isEmpty && utilityPhrases.isEmpty) {
        buffer.write('${champ.name} aporta ${traitPhrases.join(', ')}.');
      } else {
        buffer.write('También aporta ${traitPhrases.join(', ')}.');
      }
    }

    // Limpieza final
    String result = buffer.toString().trim();
    result = result.replaceAll('..', '.');
    if (!result.endsWith('.')) result += '.';
    return result;
  }

  /// Método público principal: a partir de la lista de enemigos, genera insights
  /// y devuelve las mejores recomendaciones para el rol seleccionado.
  List<StrategicRecommendation> getStrategicRecommendations(
    List<Champion> enemies,
    String selectedRole,
    List<Champion> allChampions,
  ) {
    if (enemies.isEmpty) return [];

    final insights = generateStrategicInsights(enemies);

    // === AGREGAR ESTO PARA VER LOS INSIGHTS ===
    if (kDebugMode) {
    debugPrint('=== INSIGHTS DETECTADOS ===');
    for (final insight in insights) {
      debugPrint('${insight.type}: ${insight.description}');
    }
    debugPrint('===========================');
  }

    if (insights.isEmpty) return [];

    return getBestRecommendations(insights, selectedRole, allChampions, enemies);
  }
}
