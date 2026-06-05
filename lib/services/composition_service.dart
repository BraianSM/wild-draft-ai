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

/// Insight estratégico sobre la composición enemiga
class StrategicInsight {
  final String type;
  final String description;
  final IconData icon;
  final Color color;

  const StrategicInsight({
    required this.type,
    required this.description,
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
      key: 'heal',
      label: 'heal',
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
        ? ['AD', 'AP', 'Tanques', 'CC', 'Iniciadores', 'Curas']
        : ['AD', 'AP', 'Tanques', 'CC'];
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
      _WarningRule(key: 'Tanques', threshold: 2, message: 'Muchos tanques', icon: Icons.shield, color: Colors.blueGrey),
      _WarningRule(key: 'CC', threshold: 3, message: 'Mucho control de masas', icon: Icons.link, color: Colors.orange),
      _WarningRule(key: 'Dash', threshold: 3, message: 'Muchos Desplazamientos', icon: Icons.directions_run, color: Colors.pinkAccent),
      _WarningRule(key: 'AutoAtaques', threshold: 3, message: 'Muchos autoataques', icon: Icons.touch_app, color: Colors.amber),
      _WarningRule(key: 'Curas', threshold: 2, message: 'Mucha curación', icon: Icons.healing, color: Colors.greenAccent),
      _WarningRule(key: 'Escudos', threshold: 2, message: 'Muchos escudos', icon: Icons.health_and_safety, color: Colors.cyan),
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
    final pokeCount = enemies.where((c) => championHasTag(c, 'poke')).length;
    final diveCount = enemies.where((c) => championHasTag(c, 'dive')).length;
    final pickoffCount = enemies.where((c) => championHasTag(c, 'pickoff')).length;
    final teamfightCount = enemies.where((c) => championHasTag(c, 'teamfight')).length;

    // Frontline
    if (frontline >= 2) {
  insights.add(const StrategicInsight(
    type: 'heavy_frontline',
    description: 'El enemigo posee una línea frontal muy sólida.',
    icon: Icons.shield,
    color: Colors.blueGrey,
  ));
}

    // Mucho daño físico
    if ((counts['AD'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'heavy_ad',
        description: 'La composición enemiga depende principalmente de daño físico.',
        icon: Icons.gps_fixed,
        color: AppColors.enemyRed,
      ));
    }

    // Mucho daño mágico
    if ((counts['AP'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'heavy_ap',
        description: 'El enemigo tiene una fuerte fuente de daño mágico.',
        icon: Icons.auto_awesome,
        color: Colors.purpleAccent,
      ));
    }
    
    // Muchos tanques
    if ((counts['Tank'] ?? 0) >= 2) {
      insights.add(const StrategicInsight(
        type: 'tanky',
        description: 'El enemigo tiene varios campeones resistentes.',
        icon: Icons.shield,
        color: Colors.blueGrey,
      ));
    }

    // Mucho CC
    if ((counts['CC'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'heavy_cc',
        description: 'El enemigo tiene gran capacidad para iniciar peleas y encadenar control.',
        icon: Icons.link,
        color: Colors.orange,
      ));
    }

    // Mucha movilidad
    if ((counts['Dash'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'high_mobility',
        description: 'Los campeones enemigos tienen muchos desplazamientos o dash.',
        icon: Icons.directions_run,
        color: Colors.pinkAccent,
      ));
    }

    // Dependencia de autoataques
    if ((counts['AutoAttacks'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'autoattack_reliant',
        description: 'Los ataques básicos son una fuente principal de daño enemigo.',
        icon: Icons.touch_app,
        color: Colors.amber,
      ));
    }

    // Mucha curación
    if ((counts['Heal'] ?? 0) >= 2) {
      insights.add(const StrategicInsight(
        type: 'healing',
        description: 'El enemigo cuenta con curación significativa.',
        icon: Icons.healing,
        color: Colors.greenAccent,
      ));
    }

    // Muchos escudos
    if ((counts['Shield'] ?? 0) >= 2) {
      insights.add(const StrategicInsight(
        type: 'shielding',
        description: 'El enemigo tiene múltiples escudos para protegerse.',
        icon: Icons.health_and_safety,
        color: Colors.cyan,
      ));
    }

    // Composición early game
    if ((counts['Early Game'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'early_game',
        description: 'El enemigo busca ganar temprano con campeones de early game.',
        icon: Icons.access_time,
        color: Colors.lightGreen,
      ));
    }

    // Composición late game
    if ((counts['Late Game'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'late_game',
        description: 'El enemigo escala muy bien a late game.',
        icon: Icons.trending_up,
        color: Colors.deepPurpleAccent,
      ));
    }

    // Mucho engage
    if ((counts['Engage'] ?? 0) >= 3) {
      insights.add(const StrategicInsight(
        type: 'engage',
        description: 'El enemigo tiene mucho engage e iniciación.',
        icon: Icons.flash_on,
        color: Colors.yellowAccent,
      ));
    }

    // Daño mixto balanceado
    final adCount = counts['AD'] ?? 0;
    final apCount = counts['AP'] ?? 0;
    if (adCount >= 2 && apCount >= 2) {
      insights.add(const StrategicInsight(
        type: 'mixed_damage',
        description: 'El enemigo posee fuentes equilibradas de daño físico y mágico, dificultando la itemización defensiva.',
        icon: Icons.balance,
        color: Colors.tealAccent,
      ));
    }

    // Composición de poke
    if (pokeCount >= 3) {
        insights.add(
        const StrategicInsight(
        type: 'poke',
        description: 'El enemigo busca desgastar antes de pelear.',
        icon: Icons.architecture,
      color: Colors.cyan,
       ),
      );
    }
    
    // Composicion de Frontline 
    if (frontline == 0 && teamSize >= 4) {
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
    // Composición de dive
    if (diveCount >= 3) {
    insights.add(const StrategicInsight(
    type: 'dive',
    description: 'El enemigo puede lanzarse rápidamente sobre la backline.',
    icon: Icons.flash_on,
    color: Colors.redAccent,
  ));
  }

  // Composición de pickoff
  if (pickoffCount >= 2) {
  insights.add(const StrategicInsight(
    type: 'pickoff',
    description: 'El enemigo busca atrapar objetivos aislados.',
    icon: Icons.gps_fixed,
    color: Colors.orangeAccent,
  ));
  }

  // Composición de teamfight
   if (teamfightCount >= 3) {
   insights.add(const StrategicInsight(
    type: 'teamfight',
    description: 'El enemigo destaca en peleas grupales 5v5.',
    icon: Icons.groups,
    color: Colors.deepPurpleAccent,
  ));
  }

    return insights;
  }

  /// Puntúa un campeón contra los insights de la composición enemiga.
  int scoreChampionAgainstComposition(Champion champion, List<StrategicInsight> insights) {
    int score = 0;
    bool hasSafePick = championHasTag(champion, 'safe_pick');
    bool safePickBonusApplied = false;

    for (final insight in insights) {
      switch (insight.type) {
        case 'heavy_ad':
          if (championHasTag(champion, 'anti_ad')) score += 10;
          if (championHasTag(champion, 'anti_autoattack')) score += 5;
          if (championHasTag(champion, 'frontline')) score += 3;
          if (champion.isTank) score += 2;
          if (champion.hasShield) score += 2;
          break;
        case 'heavy_frontline':
          if (championHasTag(champion, 'anti_tank')) score += 20;
          if (championHasTag(champion, 'backline_access')) score += 5;
          break;
        case 'poke':
         if  (championHasTag(champion, 'anti_poke')) score += 15;
         if (champion.hasEngage) score += 10;
         if (championHasTag(champion, 'backline_access')) score += 5;
         break;
        case 'dive':
         if (championHasTag(champion, 'anti_dive')) score += 15;
         if (championHasTag(champion, 'peel')) score += 10;
         break;
         case 'pickoff':
          if (championHasTag(champion, 'anti_pickoff')) score += 15;
          if (championHasTag(champion, 'safe_pick')) score += 10;
          if (championHasTag(champion, 'peel')) score += 10;
          if (champion.isTank) score += 5;
         break;
        case 'teamfight':
          if (championHasTag(champion, 'splitpush')) score += 15;
          if (championHasTag(champion, 'pickoff')) score += 10;
          if (championHasTag(champion, 'backline_access')) score += 10;
          if (championHasTag(champion, 'peel')) score += 5;
         break;
        case 'heavy_ap':
          if (championHasTag(champion, 'anti_ap')) score += 10;
          if (championHasTag(champion, 'frontline')) score += 5;
          if (championHasTag(champion, 'backline_access')) score += 5;
          if (champion.isTank) score += 2;
          if (champion.hasShield) score += 2;
          break;
        case 'no_frontline':
          if (championHasTag(champion, 'backline_access')) score += 15;
          if (championHasTag(champion, 'pickoff')) score += 15;
          break;
        case 'tanky':
          if (championHasTag(champion, 'anti_tank')) score += 20;
          if (championHasTag(champion, 'backline_access')) score += 10;
          break;
        case 'heavy_cc':
          if (championHasTag(champion, 'anti_cc')) score += 10;
          if (champion.hasShield) score += 2;
          break;
        case 'high_mobility':
          if (championHasTag(champion, 'anti_mobility')) score += 20;
          if (champion.hasCC) score += 5;
          break;
        case 'autoattack_reliant':
          if (championHasTag(champion, 'anti_autoattack')) score += 15;
          if (champion.hasShield) score += 3;
          if (champion.isTank) score += 2;
          break;
        case 'healing':
          if (championHasTag(champion, 'anti_heal')) score += 15;
          if (champion.hasCC) score += 5;
          if (championHasTag(champion, 'pickoff')) score += 5;
          break;
        case 'shielding':
          if (championHasTag(champion, 'anti_shield')) score += 15;
          if (championHasTag(champion, 'backline_access')) score += 5;
          if (championHasTag(champion, 'pickoff')) score += 5;
          if (champion.hasEngage) score += 3;
          break;
        case 'early_game':
          if (champion.scalesLateGame) score += 10;
          if (championHasTag(champion, 'safe_pick')) score += 5;
          break;
        case 'late_game':
          if (championHasTag(champion, 'strong_early')) score += 5;
          if (champion.isEarlyGame) score += 10;
          break;
        case 'engage':
          if (championHasTag(champion, 'anti_engage')) score += 10;
          if (championHasTag(champion, 'peel')) score += 10;
          if (championHasTag(champion, 'frontline')) score += 5;
          break;
        case 'mixed_damage':
          if (championHasTag(champion, 'pickoff')) score += 7;
          if (championHasTag(champion, 'dive')) score += 6;
          if (championHasTag(champion, 'splitpush')) score += 6;
          if (champion.hasEngage) score += 8;
          break;
      }

      if (!safePickBonusApplied && hasSafePick) {
  int safePickScore = 0;

  // Base de seguridad del campeón
  if (champion.scalesLateGame) {
    safePickScore += 2;
  }

  if (championHasTag(champion, 'peel')) {
    safePickScore += 2;
  }

  if (championHasTag(champion, 'waveclear')) {
    safePickScore += 1;
  }

  if (championHasTag(champion, 'anti_engage')) {
    safePickScore += 2;
  }

  if (championHasTag(champion, 'anti_dive')) {
    safePickScore += 2;
  }

  // Ajuste contextual (enemigo)
  if (insight.type == 'engage' &&
      championHasTag(champion, 'anti_engage')) {
    safePickScore += 2;
  }

  if (insight.type == 'dive' &&
      championHasTag(champion, 'anti_dive')) {
    safePickScore += 2;
  }

  if (insight.type == 'poke' &&
      championHasTag(champion, 'waveclear')) {
    safePickScore += 1;
  }

  // Aplicación final del bonus
  if (safePickScore >= 4) {
    score += 3;
    safePickBonusApplied = true;
   }
  }
 }

   return score;

}

  /// FASE 3: Obtiene los mejores campeones para el rol contra la composición enemiga
  List<StrategicRecommendation> getBestRecommendations(
    List<StrategicInsight> insights,
    String selectedRole,
    List<Champion> allChampions,
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

  debugPrint('${champ.name}: $score');

  if (score > 0) {
    scored.add(MapEntry(champ, score));
  }
}
      

    // Ordenar por puntuación descendente
    scored.sort((a, b) => b.value.compareTo(a.value));

    for (final entry in scored.take(10)) {
     debugPrint('${entry.key.name}: ${entry.value}');
     }

    // Aplicar diversidad: solo un campeón por perfil de tags activados
    final seenProfiles = <String>{};
    final uniqueTop = <MapEntry<Champion, int>>[];

    for (final entry in scored) {
      final profile = _getChampionProfile(entry.key, insights);

      debugPrint('${entry.key.name} -> $profile -> ${entry.value}');
      if (!seenProfiles.contains(profile)) {
        seenProfiles.add(profile);
        uniqueTop.add(entry);
      }
      if (uniqueTop.length >= 3) break;
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

  /// Genera un perfil de tags activados para un campeón, para agrupar similares.
  String _getChampionProfile(Champion champ, List<StrategicInsight> insights) {
    final tags = <String>[];
    for (final insight in insights) {
      switch (insight.type) {
        case 'poke':
         if (championHasTag(champ, 'anti_poke')) tags.add('anti_poke');
         break;
        case 'dive':if (championHasTag(champ, 'anti_dive')) tags.add('anti_dive');
         break;
        case 'pickoff':if (championHasTag(champ, 'anti_pickoff')) tags.add('anti_pickoff');
         break;
        case 'teamfight':
         if (championHasTag(champ, 'anti_teamfight')) tags.add('anti_teamfight');
         break;
        case 'heavy_ad':
          if (championHasTag(champ, 'anti_ad')) tags.add('anti_ad');
          break;
        case 'heavy_ap':
          if (championHasTag(champ, 'anti_ap')) tags.add('anti_ap');
          break;
        case 'no_frontline':
          if (championHasTag(champ, 'backline_access')) tags.add('backline');
          if (championHasTag(champ, 'pickoff')) tags.add('pickoff');
          break;
        case 'tanky':
          if (championHasTag(champ, 'anti_tank')) tags.add('anti_tank');
          break;
        case 'heavy_cc':
          if (championHasTag(champ, 'anti_cc')) tags.add('anti_cc');
          if (championHasTag(champ, 'safe_pick')) tags.add('safe');
          break;
        case 'heavy_frontline':
          if (championHasTag(champ, 'anti_tank')) tags.add('anti_tank');
          if (championHasTag(champ, 'backline_access')) tags.add('backline');
          break;
        case 'high_mobility':
          if (championHasTag(champ, 'anti_dash')) tags.add('anti_dash');
          if (championHasTag(champ, 'safe_pick')) tags.add('safe');
          break;
        case 'autoattack_reliant':
          if (championHasTag(champ, 'anti_autoattack')) tags.add('anti_autoattack');
          break;
        case 'healing':
          if (championHasTag(champ, 'anti_heal')) tags.add('anti_heal');
          break;
        case 'shielding':
          if (championHasTag(champ, 'anti_shield')) tags.add('anti_shield');
          break;
        case 'early_game':
          if (championHasTag(champ, 'scaling')) tags.add('scaling');
          break;
        case 'late_game':
          if (championHasTag(champ, 'strong_early')) tags.add('strong_early');
          break;
        case 'engage':
          if (championHasTag(champ, 'anti_engage')) tags.add('anti_engage');
          break;
        case 'mixed_damage':
          if (championHasTag(champ, 'frontline')) tags.add('frontline');
          break;
      }
    }
    tags.sort();
    return tags.join('|');
  }

  /// Genera una razón humana y estratégica para la recomendación.
  String generateRecommendationReason(Champion champ, List<StrategicInsight> insights) {
    // Recopilar todos los tags que contribuyeron significativamente
    final activatedTags = <String>[];
    final activatedAttrs = <String>[];

    for (final insight in insights) {
      switch (insight.type) {
        case 'heavy_frontline':
         if (championHasTag(champ, 'anti_tank')) activatedTags.add('anti_tank');
         if (championHasTag(champ, 'backline_access')) activatedTags.add('backline_access');
         break;
        case 'poke':
         if (championHasTag(champ, 'anti_poke')) activatedTags.add('anti_poke');
         break;         
        case 'dive':
         if (championHasTag(champ, 'anti_dive')) activatedTags.add('anti_dive');
         break;
        case 'pickoff':
         if (championHasTag(champ, 'anti_pickoff')) activatedTags.add('anti_pickoff');
         break;
        case 'teamfight':
         if (championHasTag(champ, 'anti_teamfight')) activatedTags.add('anti_teamfight');
         break;
        case 'heavy_ad':
          if (championHasTag(champ, 'anti_ad')) activatedTags.add('anti_ad');
          if (championHasTag(champ, 'anti_autoattack')) activatedTags.add('anti_autoattack');
          if (champ.isTank) activatedAttrs.add('tanque');
          break;
        case 'heavy_ap':
          if (championHasTag(champ, 'anti_ap')) activatedTags.add('anti_ap');
          if (champ.isTank) activatedAttrs.add('tanque');
          if (champ.hasShield) activatedAttrs.add('escudos');
          break;
        case 'no_frontline':
          if (championHasTag(champ, 'backline_access')) activatedTags.add('backline_access');
          if (championHasTag(champ, 'pickoff')) activatedTags.add('pickoff');
          break;
        case 'tanky':
          if (championHasTag(champ, 'anti_tank')) activatedTags.add('anti_tank');
          break;
        case 'heavy_cc':
          if (championHasTag(champ, 'anti_cc')) activatedTags.add('anti_cc');
          if (championHasTag(champ, 'safe_pick')) activatedTags.add('safe_pick');
          if (champ.hasShield) activatedAttrs.add('escudos');
          break;
        case 'high_mobility':
          if (championHasTag(champ, 'anti_dash')) activatedTags.add('anti_dash');
          if (championHasTag(champ, 'safe_pick')) activatedTags.add('safe_pick');
          if (champ.hasCC) activatedAttrs.add('CC');
          break;
        case 'autoattack_reliant':
          if (championHasTag(champ, 'anti_autoattack')) activatedTags.add('anti_autoattack');
          if (champ.hasShield) activatedAttrs.add('escudos');
          break;
        case 'healing':
          if (championHasTag(champ, 'anti_heal')) activatedTags.add('anti_heal');
          break;
        case 'shielding':
          if (championHasTag(champ, 'anti_shield')) activatedTags.add('anti_shield');
          break;
        case 'early_game':
          if (championHasTag(champ, 'scaling')) activatedTags.add('scaling');
          if (champ.scalesLateGame) activatedAttrs.add('late game');
          break;
        case 'late_game':
          if (championHasTag(champ, 'strong_early')) activatedTags.add('strong_early');
          if (champ.isEarlyGame) activatedAttrs.add('early game');
          break;
        case 'engage':
          if (championHasTag(champ, 'anti_engage')) activatedTags.add('anti_engage');
          if (championHasTag(champ, 'safe_pick')) activatedTags.add('safe_pick');
          break;
        case 'mixed_damage':
          if (championHasTag(champ, 'frontline')) activatedTags.add('frontline');
          if (champ.isTank) activatedAttrs.add('tanque');
          if (champ.hasShield) activatedAttrs.add('escudos');
          break;
      }
    }

    // Construir razones naturales basadas en los tags activados
    return _naturalReason(champ, activatedTags, activatedAttrs);
  }

  /// Convierte tags y atributos activados en una frase natural.
  String _naturalReason(Champion champ, List<String> tags, List<String> attrs) {
    // Frases específicas por combinación de tags
    bool hasTag(String t) => tags.contains(t);
    bool hasAttrs(String a) => attrs.contains(a);

    // Anti Poke
    if (hasTag('anti_poke')) {
      return '${champ.name} reduce la efectividad del poke enemigo.';
    }

    // Anti Dive 
    if (hasTag('anti_dive')) {
      return '${champ.name} protege bien a su equipo contra campeones que se lanzan agresivamente.';
    }

    // Anti Pickoff
    if (hasTag('anti_pickoff')) {
      return '${champ.name} dificulta que el enemigo consiga picks aislados.';
    }

    // Anti Teamfight
    if (hasTag('anti_teamfight')) {
      return '${champ.name} puede romper las peleas grupales que busca esta composición.';
    }

    // Mixed damage
    if (hasTag('frontline') && (hasAttrs('tanque') || hasAttrs('escudos'))) {
      return '${champ.name} ofrece resistencia versátil contra daño mixto, ideal contra esta composición equilibrada.';
    }
    // Anti-AD y anti-autoattack juntos
    if (hasTag('anti_ad') && hasTag('anti_autoattack')) {
      return '${champ.name} castiga equipos que dependen de daño físico y ataques básicos.';
    }
    // Anti-AP prominente
    if (hasTag('anti_ap') && hasTag('anti_cc')) {
      return '${champ.name} destaca contra composiciones con mucho daño mágico gracias a su resistencia y capacidad de iniciación.';
    }
    // Anti-CC con safe_pick
    if (hasTag('anti_cc') && hasTag('safe_pick')) {
      return '${champ.name} puede bloquear habilidades clave y reducir el impacto del control enemigo.';
    }
    // Anti-dash con CC
    if (hasTag('anti_dash') && hasAttrs('CC')) {
      return '${champ.name} su control dirigido dificulta que campeones móviles ejecuten sus planes.';
    }
    // Anti-tank
    if (hasTag('anti_tank')) {
      return '${champ.name} es una excelente respuesta contra tanques enemigos.';
    }
    // Backline_access o pickoff
    if (hasTag('backline_access') || hasTag('pickoff')) {
      return '${champ.name} puede acceder a los carries enemigos y castigar su falta de protección.';
    }
    // Anti-heal
    if (hasTag('anti_heal')) {
      return '${champ.name} reduce drásticamente la curación enemiga.';
    }
    // Anti-shield
    if (hasTag('anti_shield')) {
      return '${champ.name} puede romper o ignorar los escudos enemigos.';
    }
    // Scaling contra early game
    if (hasTag('scaling')) {
      return '${champ.name} escala muy bien a late game, sobreviviendo al early enemigo.';
    }
    // Strong early contra late game
    if (hasTag('strong_early')) {
      return '${champ.name} puede cerrar la partida antes de que el enemigo escale.';
    }
    // Anti-engage con safe_pick
    if (hasTag('anti_engage') && hasTag('safe_pick')) {
      return '${champ.name} es difícil de atrapar y contrarresta la iniciación enemiga.';
    }
    // Safe_pick genérico
    if (hasTag('safe_pick')) {
      return '${champ.name} es un pick seguro y versátil contra esta composición.';
    }
    // Solo anti_ad
    if (hasTag('anti_ad')) {
      return '${champ.name} resiste bien el daño físico enemigo.';
    }
    // Solo anti_ap
    if (hasTag('anti_ap')) {
      return '${champ.name} tiene alta resistencia mágica contra este equipo AP.';
    }
    // Solo anti_cc
    if (hasTag('anti_cc')) {
      return '${champ.name} puede mitigar el control de masas enemigo.';
    }
    // Solo anti_dash
    if (hasTag('anti_dash')) {
      return '${champ.name} detiene la movilidad enemiga.';
    }
    // Solo anti_autoattack
    if (hasTag('anti_autoattack')) {
      return '${champ.name} reduce el impacto de los ataques básicos enemigos.';
    }
    // Atributos genéricos
    if (hasAttrs('tanque') && hasAttrs('escudos')) {
      return '${champ.name} es un tanque con escudos, ideal contra este equipo.';
    }
    if (hasAttrs('tanque')) {
      return '${champ.name} ofrece una sólida línea frontal contra el enemigo.';
    }
    if (hasAttrs('escudos')) {
      return '${champ.name} puede proteger a su equipo con escudos oportunos.';
    }
    if (hasAttrs('CC')) {
      return '${champ.name} contribuye con control para neutralizar amenazas.';
    }
    if (hasAttrs('late game')) {
      return '${champ.name} escala a late game y sobrevive al early enemigo.';
    }
    if (hasAttrs('early game')) {
      return '${champ.name} presiona mucho en early para cerrar la partida rápido.';
    }
    // Fallback
    return '${champ.name} es una buena elección contra esta composición.';
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
    debugPrint('=== INSIGHTS DETECTADOS ===');
    for (final insight in insights) {
      debugPrint('${insight.type}: ${insight.description}');
    }
    debugPrint('===========================');

    if (insights.isEmpty) return [];

    return getBestRecommendations(insights, selectedRole, allChampions);
  }
}