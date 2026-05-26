// SERVICIO: Maneja toda la lógica del draft
// Incluye sistema simple de counters

import '../models/champion.dart';
import '../data/champions_data.dart';

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

  // ========== SISTEMA DE COUNTERS ==========
  
  /// Mapa de counters: cada campeón tiene una lista de campeones que lo counterean
  /// Formato: 'NombreCampeón_Rol': ['Counter1', 'Counter2', ...]
  final Map<String, List<String>> _countersMap = {
    // TOP
    'Aatrox_TOP': ['Fiora', 'Renekton', 'Irelia', 'Tryndamere'],
    'Camille_TOP': ['Darius', 'Renekton', 'Fiora', 'Jax'],
    'Darius_TOP': ['Renekton', 'Fiora', 'Tryndamere', 'Wukong'],
    'Dr. Mundo_TOP': ['Fiora', 'Renekton', 'Tryndamere', 'Darius'],
    'Fiora_TOP': ['Malphite', 'Renekton', 'Nasus', 'Camille'],
    'Garen_TOP': ['Darius', 'Fiora', 'Camille', 'Renekton'],
    'Gnar_TOP': ['Darius', 'Renekton', 'Fiora', 'Irelia'],
    'Gwen_TOP': ['Renekton', 'Darius', 'Fiora', 'Tryndamere'],
    'Irelia_TOP': ['Malphite', 'Renekton', 'Jax', 'Fiora'],
    'Jax_TOP': ['Malphite', 'Renekton', 'Darius', 'Sett'],
    'Jayce_TOP': ['Malphite', 'Renekton', 'Irelia', 'Fiora'],
    'K\'Sante_TOP': ['Fiora', 'Renekton', 'Darius', 'Tryndamere'],
    'Kayle_TOP': ['Renekton', 'Darius', 'Fiora', 'Tryndamere'],
    'Kennen_TOP': ['Malphite', 'Renekton', 'Irelia', 'Fiora'],
    'Malphite_TOP': ['Darius', 'Fiora', 'Camille', 'Sett'],
    'Mordekaiser_TOP': ['Fiora', 'Renekton', 'Darius', 'Tryndamere'],
    'Nasus_TOP': ['Darius', 'Renekton', 'Tryndamere', 'Fiora'],
    'Ornn_TOP': ['Fiora', 'Renekton', 'Darius', 'Tryndamere'],
    'Poppy_TOP': ['Darius', 'Renekton', 'Sett', 'Fiora'],
    'Renekton_TOP': ['Darius', 'Fiora', 'Gnar', 'Pantheon'],
    'Riven_TOP': ['Malphite', 'Renekton', 'Darius', 'Garen'],
    'Sett_TOP': ['Darius', 'Fiora', 'Renekton', 'Vayne'],
    'Shen_TOP': ['Darius', 'Mordekaiser', 'Sett', 'Teemo'],
    'Singed_TOP': ['Darius', 'Renekton', 'Fiora', 'Tryndamere'],
    'Sion_TOP': ['Fiora', 'Renekton', 'Darius', 'Nasus'],
    'Teemo_TOP': ['Malphite', 'Renekton', 'Darius', 'Fiora'],
    'Tryndamere_TOP': ['Malphite', 'Renekton', 'Nasus', 'Darius'],
    'Urgot_TOP': ['Fiora', 'Renekton', 'Darius', 'Tryndamere'],
    'Volibear_TOP': ['Darius', 'Fiora', 'Renekton', 'Tryndamere'],
    'Wukong_TOP': ['Darius', 'Renekton', 'Fiora', 'Sett'],

    // JG
    'Amumu_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Diana_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Ekko_JG': ['Lee Sin', 'Xin Zhao', 'Jarvan IV', 'Graves'],
    'Evelynn_JG': ['Lee Sin', 'Rengar', 'Kha\'Zix', 'Warwick'],
    'Gragas_JG': ['Lee Sin', 'Xin Zhao', 'Jarvan IV', 'Graves'],
    'Graves_JG': ['Xin Zhao', 'Lee Sin', 'Jarvan IV', 'Vi'],
    'Jarvan IV_JG': ['Lee Sin', 'Xin Zhao', 'Vi', 'Graves'],
    'Kha\'Zix_JG': ['Lee Sin', 'Rengar', 'Xin Zhao', 'Warwick'],
    'Lee Sin_JG': ['Xin Zhao', 'Jarvan IV', 'Vi', 'Graves'],
    'Lillia_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Maokai_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Master Yi_JG': ['Rammus', 'Amumu', 'Jax', 'Warwick'],
    'Nocturne_JG': ['Rammus', 'Warwick', 'Trundle'],
    'Nunu y Willump_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Olaf_JG': ['Lee Sin', 'Xin Zhao', 'Jarvan IV', 'Graves'],
    'Pantheon_JG': ['Lee Sin', 'Xin Zhao', 'Jarvan IV', 'Vi'],
    'Poppy_JG': ['Lee Sin', 'Xin Zhao', 'Jarvan IV', 'Graves'],
    'Rammus_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Rengar_JG': ['Lee Sin', 'Xin Zhao', 'Warwick', 'Graves'],
    'Shen_JG': ['Nocturne', 'Viego', 'Lillia', 'Olaf'],
    'Shyvana_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Taliyah_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Talon_JG': ['Lee Sin', 'Xin Zhao', 'Warwick', 'Graves'],
    'Vi_JG': ['Lee Sin', 'Xin Zhao', 'Jarvan IV', 'Graves'],
    'Warwick_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Xin Zhao_JG': ['Lee Sin', 'Jarvan IV', 'Vi', 'Graves'],
    'Zed_JG': ['Lee Sin', 'Xin Zhao', 'Warwick', 'Graves'],

    // MID
    'Ahri_MID': ['Fizz', 'Zed', 'Yasuo'],
    'Akali_MID': ['Zed', 'Fizz', 'Yasuo'],
    'Akshan_MID': ['Annie', 'Malphite', 'Pantheon', 'Irelia'],
    'Annie_MID': ['Fizz', 'Zed', 'Akali'],
    'Aurelion Sol_MID': ['Fizz', 'Zed', 'Akali'],
    'Brand_MID': ['Fizz', 'Zed', 'Akali'],
    'Fizz_MID': ['Zed', 'Ahri', 'Lux'],
    'Galio_MID': ['Fizz', 'Zed', 'Yasuo', 'Akali'],
    'Irelia_MID': ['Malphite', 'Renekton', 'Jax', 'Fiora'],
    'Karma_MID': ['Fizz', 'Zed', 'Akali'],
    'Kassadin_MID': ['Zed', 'Fizz', 'Yasuo', 'Ahri'],
    'Lissandra_MID': ['Galio', 'Kassadin', 'Ziggs', 'Lux', 'Orianna'],
    'Lucian_MID': ['Fizz', 'Zed', 'Akali', 'Yasuo'],
    'Lux_MID': ['Fizz', 'Zed', 'Akali'],
    'Morgana_MID': ['Fizz', 'Zed', 'Akali'],
    'Orianna_MID': ['Fizz', 'Zed', 'Akali'],
    'Taliyah_MID': ['Fizz', 'Zed', 'Akali'],
    'Talon_MID': ['Fizz', 'Zed', 'Akali', 'Yasuo'],
    'Twisted Fate_MID': ['Fizz', 'Zed', 'Akali'],
    'Veigar_MID': ['Fizz', 'Zed', 'Akali'],
    'Vel\'Koz_MID': ['Fizz', 'Zed', 'Akali'],
    'Vladimir_MID': ['Fizz', 'Zed', 'Ahri'],
    'Yasuo_MID': ['Malphite', 'Annie', 'Renekton', 'Riven'],
    'Yone_MID': ['Malphite', 'Renekton', 'Fiora', 'Jax'],
    'Zed_MID': ['Lissandra', 'Malphite', 'Fizz', 'Ahri'],
    'Ziggs_MID': ['Fizz', 'Zed', 'Akali'],
    'Zoe_MID': ['Fizz', 'Zed', 'Akali'],

    // ADC
    'Ashe_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Caitlyn_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Corki_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Draven_ADC': ['Caitlyn', 'Ashe', 'Jhin', 'Tristana'],
    'Ezreal_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Jhin_ADC': ['Tristana', 'Draven', 'Samira', 'Ashe'],
    'Jinx_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Kai\'Sa_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Kog\'Maw_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Lucian_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Miss Fortune_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Samira_ADC': ['Caitlyn', 'Ashe', 'Jhin', 'Vayne'],
    'Senna_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Sivir_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Tristana_ADC': ['Caitlyn', 'Draven', 'Jhin', 'Samira'],
    'Twitch_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Varus_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Vayne_ADC': ['Caitlyn', 'Ashe', 'Draven', 'Jhin'],
    'Xayah_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Ziggs_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],

    // SUPP
    'Alistar_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Blitzcrank_SUPP': ['Morgana', 'Janna', 'Lulu', 'Sivir'],
    'Braum_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Janna_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Leona_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Lulu_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Nami_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Nautilus_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Pyke_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Rakan_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Seraphine_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Sona_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Soraka_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Thresh_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Yuumi_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Annie_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Brand_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Galio_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Karma_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Lux_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Maokai_SUPP': ['Morgana', 'Janna', 'Lulu', 'Soraka'],
    'Morgana_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Shen_SUPP': ['Morgana', 'Janna', 'Lulu', 'Zyra', 'Brand' ],
    'Senna_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Veigar_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Vel\'Koz_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Zyra_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
  };

  /// Obtiene recomendaciones de counter para los enemigos seleccionados
  /// Busca en el mapa usando el formato: 'Nombre_Rol'
  /// Si no encuentra con el rol, busca solo por nombre como fallback
  List<Champion> obtenerCountersPorRol(String rolJugador) {
    if (enemyPicks.isEmpty) return [];
    
    // Set para evitar duplicados
    Set<String> nombresCounters = {};
    
    // Por cada enemigo, obtener sus counters
    for (var enemigo in enemyPicks) {
      // Obtener el rol principal del enemigo
      String rolEnemigo = enemigo.primaryRole;
      
      // Crear la clave con formato: 'Nombre_Rol'
      String claveConRol = '${enemigo.name}_$rolEnemigo';
      
      // Buscar primero con la clave que incluye el rol
      if (_countersMap.containsKey(claveConRol)) {
        for (var counterNombre in _countersMap[claveConRol]!) {
          // No incluir si ya está seleccionado (aliado o enemigo)
          if (!isChampionSelectedByName(counterNombre)) {
            nombresCounters.add(counterNombre);
          }
        }
      }
      // Si no encuentra con rol, buscar solo por nombre (fallback)
      else if (_countersMap.containsKey(enemigo.name)) {
        for (var counterNombre in _countersMap[enemigo.name]!) {
          if (!isChampionSelectedByName(counterNombre)) {
            nombresCounters.add(counterNombre);
          }
        }
      }
    }
    
    // Convertir los nombres a objetos Champion
    List<Champion> recomendaciones = [];
    List<Champion> todosLosCampeones = ChampionsData.getAll();
    
    for (var nombre in nombresCounters) {
      for (var campeon in todosLosCampeones) {
        // Filtrar por el rol seleccionado del jugador
        if (campeon.name == nombre &&  
             campeon.roles.contains(rolJugador) &&
            !recomendaciones.contains(campeon)) {
          recomendaciones.add(campeon);
        }
      }
    }
    
    // Limitar a máximo 3 recomendaciones
    if (recomendaciones.length > 3) {
      recomendaciones = recomendaciones.sublist(0, 3);
    }
    
    return recomendaciones;
  }

  /// Verifica si un campeón por nombre ya está seleccionado
  bool isChampionSelectedByName(String name) {
    bool isAlly = alliedPicks.any((c) => c.name == name);
    bool isEnemy = enemyPicks.any((c) => c.name == name);
    return isAlly || isEnemy;
  }
}