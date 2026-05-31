// SERVICIO: Maneja la lógica básica del draft
// La lógica de counters se movió a counter_service.dart

import '../models/champion.dart';

class DraftService {
  List<Champion> alliedPicks = [];
  List<Champion> enemyPicks = [];

  final int maxPicks = 5;

  bool isChampionSelected(Champion champion) {
    bool isAlly = alliedPicks.any((c) => c.name == champion.name);
    bool isEnemy = enemyPicks.any((c) => c.name == champion.name);
    return isAlly || isEnemy;
  }

  void pickAsAlly(Champion champion) {
    if (alliedPicks.length < maxPicks && !isChampionSelected(champion)) {
      alliedPicks.add(champion);
    }
  }

  void pickAsEnemy(Champion champion) {
    if (enemyPicks.length < maxPicks && !isChampionSelected(champion)) {
      enemyPicks.add(champion);
    }
  }

  void removeAllyPick(int index) {
    if (index >= 0 && index < alliedPicks.length) {
      alliedPicks.removeAt(index);
    }
  }

  void removeEnemyPick(int index) {
    if (index >= 0 && index < enemyPicks.length) {
      enemyPicks.removeAt(index);
    }
  }

  void resetDraft() {
    alliedPicks.clear();
    enemyPicks.clear();
  }
}