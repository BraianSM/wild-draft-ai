// SERVICIO: Maneja toda la lógica del draft
// Controla las listas de aliados, enemigos y la selección de campeones

import '../models/champion.dart';

class DraftService {
  // Listas separadas para cada equipo
  List<Champion> alliedPicks = [];
  List<Champion> enemyPicks = [];

  // Máximo de campeones por equipo
  final int maxPicks = 5;

  /// Verifica si un campeón ya fue seleccionado en algún equipo
  bool isChampionSelected(Champion champion) {
    bool isAlly = alliedPicks.any((c) => c.name == champion.name);
    bool isEnemy = enemyPicks.any((c) => c.name == champion.name);
    return isAlly || isEnemy;
  }

  /// Agrega un campeón a la lista de aliados
  void pickAsAlly(Champion champion) {
    if (alliedPicks.length < maxPicks && !isChampionSelected(champion)) {
      alliedPicks.add(champion);
    }
  }

  /// Agrega un campeón a la lista de enemigos
  void pickAsEnemy(Champion champion) {
    if (enemyPicks.length < maxPicks && !isChampionSelected(champion)) {
      enemyPicks.add(champion);
    }
  }

  /// Elimina un campeón de aliados por su índice
  void removeAllyPick(int index) {
    if (index >= 0 && index < alliedPicks.length) {
      alliedPicks.removeAt(index);
    }
  }

  /// Elimina un campeón de enemigos por su índice
  void removeEnemyPick(int index) {
    if (index >= 0 && index < enemyPicks.length) {
      enemyPicks.removeAt(index);
    }
  }

  /// Reinicia todo el draft (borra todas las selecciones)
  void resetDraft() {
    alliedPicks.clear();
    enemyPicks.clear();
  }
}