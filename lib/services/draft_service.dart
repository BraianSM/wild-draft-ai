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
    'Aatrox_TOP': ['Fiora', 'Gwen', 'Jax', 'Vayne'],
    'Aurora_TOP': ['Irelia', 'Poppy', 'Vladimir', 'Singed'],
    'Camille_TOP': ['Renekton', 'Darius', 'Fiora', 'Jax'],
    'Darius_TOP': ['Renekton', 'Fiora', 'Tryndamere', 'Wukong'],
    'Dr.Mundo_TOP': ['Fiora', 'Renekton', 'Tryndamere', 'Darius'],
    'Fiora_TOP': ['Malphite', 'Jax', 'Renekton', 'Pantheon'],
    'Garen_TOP': ['Vayne', 'Fiora', 'Camille', 'Darius'],
    'Gnar_TOP': ['Malphite', 'Irelia', 'Ornn', 'Teemo'],
    'Gwen_TOP': ['Pantheon', 'Darius', 'Fiora', 'Tryndamere'],
    'Irelia_TOP': ['Pantheon', 'Renekton', 'Jax', 'Fiora'],
    'Jax_TOP': ['Garen', 'Teemo', 'Pantheon', 'Sett'],
    'Jayce_TOP': ['Malphite', 'Pantheon', 'Irelia', 'Fiora'],
    'K\'Sante_TOP': ['Garen', 'Rumble', 'Fiora', 'Kayle'],
    'Kayle_TOP': ['Pantheon', 'Renekton', 'Fiora', 'Tryndamere'],
    'Kennen_TOP': ['Malphite', 'Nasus', 'Dr.Mundo', 'Galio'],
    'Malphite_TOP': ['Singed', 'Ornn', 'Dr.Mundo', 'Sion'],
    'Mordekaiser_TOP': ['Fiora', 'Olaf', 'Darius', 'Tryndamere'],
    'Nasus_TOP': ['Garen', 'Renekton', "K\'Sante", 'Fiora'],
    'Ornn_TOP': ['Singed', 'Garen', 'Darius', 'Olaf'],
    'Poppy_TOP': ['Darius', 'Renekton', 'Sett', 'Fiora'],
    'Renekton_TOP': ['Dr.Mundo', 'Darius', 'Gnar', 'Pantheon'],
    'Riven_TOP': ['Renekton', 'Poppy', 'Kennen', 'Garen'],
    'Rumble_TOP':['Galio', 'Ryze', 'Aurora', 'Kayle'],
    'Sett_TOP': ['Pantheon', 'Darius', 'Vayne', 'Singed'],
    'Shen_TOP': ['Darius', 'Mordekaiser', 'Sett', 'Teemo'],
    'Singed_TOP': ['Vayne', 'Jayce', 'Nasus', 'Ryze'],
    'Sion_TOP': ['Darius', 'Shen', 'Singed', 'Irelia'],
    'Teemo_TOP': ['Rumble', 'Akali', 'Ryze', 'Olaf'],
    'Tryndamere_TOP': ['Malphite', 'Teemo', 'Jax', 'Volibear'],
    'Urgot_TOP': ['Olaf', 'Kayle', 'Sion', 'Tryndamere'],
    'Varus_TOP': ['Olaf', 'Yasuo', 'Irelia', 'Nasus'],
    'Vayne_TOP': ['Teemo', 'Malphite', 'Pantheon', 'Irelia'],
    'Volibear_TOP': ['Jax', 'Fiora', 'Teemo', 'Urgot'],
    'Wukong_TOP': ['Mordekaiser', 'Ornn', 'Poppy', 'Sett'],

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
    'Nocturne_JG': ['Rammus', 'Warwick', 'Evelynn', 'Lillia'],
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
    'Viego_JG': ['Rammus', 'Olaf', 'Taliyah', 'Amumu'],
    'Warwick_JG': ['Lee Sin', 'Xin Zhao', 'Graves', 'Olaf'],
    'Xin Zhao_JG': ['Lee Sin', 'Jarvan IV', 'Vi', 'Graves'],
    'Zed_JG': ['Lee Sin', 'Xin Zhao', 'Warwick', 'Graves'],

    // MID
    'Ahri_MID': ['Mel', 'Galio', 'Zed', 'Brand'],
    'Aurora_MID': ['Fizz', 'Diana', 'Galio', 'Irelia'],
    'Akali_MID': ['Vel Koz', 'Twisted Fate', 'Jayce', 'Pantheon'],
    'Akshan_MID': ['Annie', 'Malphite', 'Pantheon', 'Irelia'],
    'Annie_MID': ['Orianna', 'Brand', 'Diana', 'Irelia'],
    'Aurelion Sol_MID': ['Yone', 'Irelia', 'Akshan', 'Zed'],
    'Brand_MID': ['Aurelion Sol', 'Ziggs', 'Orianna', 'Veigar'],
    'Ekko_MID': ['Talon', 'Vex', 'Lissandra', 'Zoe'],
    'Fizz_MID': ['Vex', 'Talon', 'Viktor', 'Diana'],
    'Galio_MID': ['Aurelion Sol', 'Kassadin', 'Zoe', 'Zed'],
    'Irelia_MID': ['Vex', 'Talon', 'Ekko', 'Zoe'],
    'Karma_MID': ['Ryze', 'Annie', 'Veigar', 'Twisted Fate'],
    'Kassadin_MID': ['Zed', 'Talon', 'Yasuo', 'Yone'],
    'Lissandra_MID': ['Aurora', 'Vel Koz', 'Syndra', 'Lux'],
    'Lucian_MID': ['Irelia', 'Veigar', 'Talon', 'Ryze'],
    'Lux_MID': ['Taliyah', 'Zed', 'Katarina', 'Fizz'],
    'Mel_MID': ['Irelia', 'Zed', 'Diana', 'Ryze'],
    'Morgana_MID': ['Taliyah', 'Zed', 'Jayce', 'Mel'],
    'Norra_MID': ['Ekko', 'Zoe', 'Ahri', 'Kassadin'],
    'Orianna_MID': ['Talon', 'Vel Koz', 'Zoe', 'Diana'],
    'Syndra_MID': ['Vel Koz', 'Zed', 'Katarina', 'Diana'],
    'Swain_MID': ['Katarina', 'Aurelion Sol', 'Syndra', 'Vel\'Koz'],
    'Taliyah_MID': ['Fizz', 'Brand', 'Ahri', 'Galio'],
    'Talon_MID': ['Akshan', 'Mel', 'Ryze', 'Zed'],
    'Twisted Fate_MID': ['Fizz', 'Zed', 'Irelia', 'Veigar'],
    'Veigar_MID': ['Zed', 'Vladimir', 'Lux', 'Katarina'],
    'Vel\'Koz_MID': ['Talon', 'Zoe', 'Mel', 'Diana'],
    'Vex_MID': ['Mel', 'Diana', 'Twisted Fate', 'Taliyah'],
    'Vladimir_MID': ['Orianna', 'Zoe', 'Vel Koz', 'Irelia'],
    'Yasuo_MID': ['Renekton', 'Pantheon', 'Irelia', 'Riven'],
    'Yone_MID': ['Taliyah', 'Aurora', 'Vex', 'Annie'],
    'Zed_MID': ['Lissandra', 'Ekko', 'Diana', 'Irelia'],
    'Ziggs_MID': ['Akshan', 'Aurelion Sol', 'Irelia', 'Diana'],
    'Zoe_MID': ['Mel', 'Diana', 'Annie', 'Twisted Fate'],

    // ADC
    'Ashe_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Caitlyn_ADC': ['Draven', 'Samira', 'Xayah', 'Varus'],
    'Corki_ADC': ['Nilah', 'Varus', 'Caitlyn', 'Tristana'],
    'Draven_ADC': ['Vel Koz', 'Swain', 'Varus', 'Xayah'],
    'Ezreal_ADC': ['Kog Maw', 'Draven', 'Zeri', 'Varus'],
    'Jhin_ADC': ['Draven', 'Samira', 'Tristana', 'Kalista'],
    'Jinx_ADC': ['Nilah', 'Draven', 'Kalista', 'Corki'],
    'Kalista_ADC': ['Varus', 'Mel', 'Corki', 'Sivir'],
    'Kai\'Sa_ADC': ['Nilah', 'Draven', 'Varus', 'Samira'],
    'Kog\'Maw_ADC': ['Corki', 'Draven', 'Nilah', 'Kalista'],
    'Lucian_ADC': ['Corki', 'Draven', 'Lux', 'Samira'],
    'Miss Fortune_ADC': ['Kog Maw', 'Samira', 'Draven', 'Zeri'],
    'Nilah_ADC': ['Kalista', 'Xayah', 'Swain', 'Varus'],
    'Samira_ADC': ['Caitlyn', 'Ashe', 'Lucian', 'Jinx'],
    'Sivir_ADC': ['Tristana', 'Twitch', 'Draven', 'Mel'],
    'Tristana_ADC': ['Draven', 'Lucian', 'Mel', 'Samira'],
    'Twitch_ADC': ['Nilah', 'Zeri', 'Draven', 'Kalista'],
    'Varus_ADC': ['Kog Maw', 'Draven', 'Mel', 'Samira'],
    'Vayne_ADC': ['Caitlyn', 'Senna', 'Zeri', 'Draven'],
    'Xayah_ADC': ['Ashe', 'Draven', 'Kalista', 'Tristana'],
    'Ziggs_ADC': ['Lucian', 'Kog Maw', 'Draven', 'Nilah'],

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
    'Swain_SUPP': ['Zilean', 'Janna', 'Seraphine', 'Brand'],
    'Veigar_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Vel\'Koz_SUPP': ['Blitzcrank', 'Leona', 'Alistar', 'Pyke'],
    'Zilean_SUPP': ['Pyke', 'Janna', 'Nami', 'Soraka'],
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
    if (recomendaciones.length > 4) {
      recomendaciones = recomendaciones.sublist(0, 4);
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