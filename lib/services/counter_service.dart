// SERVICIO: Maneja toda la lógica de counters
// Separado de DraftService para mejorar organización

import '../models/champion.dart';
import '../data/champions_data.dart';

class CounterService {
  final List<Champion> alliedPicks;
  final List<Champion> enemyPicks;
  final List<Champion> allChampions;

  CounterService({
    required this.alliedPicks,
    required this.enemyPicks,
    List<Champion>? allChampions,
  }) : allChampions = allChampions ?? ChampionsData.getAll();

  // Mapa de counters: cada campeón tiene una lista de campeones que lo counterean
  // Formato: 'NombreCampeón_Rol': ['Counter1', 'Counter2', ...]
  final Map<String, List<String>> _countersMap = {
    // TOP
    'Aatrox_TOP': ['Fiora', 'Gwen', 'Jax', 'Vayne'],
    'Aurora_TOP': ['Irelia', 'Poppy', 'Vladimir', 'Singed'],
    'Ambessa_TOP': ['Renekton', 'Poppy', 'Pantheon', 'Tryndamere'],
    'Camille_TOP': ['Renekton', 'Darius', 'Fiora', 'Jax'],
    'Darius_TOP': ['Renekton', 'Fiora', 'Tryndamere', 'Wukong'],
    'Dr.Mundo_TOP': ['Fiora', 'Irelia', 'Aatrox', 'Darius'],
    'Fiora_TOP': ['Malphite', 'Jax', 'Renekton', 'Pantheon'],
    'Garen_TOP': ['Vayne', 'Fiora', 'Camille', 'Darius'],
    'Gnar_TOP': ['Malphite', 'Irelia', 'Ornn', 'Teemo'],
    'Gwen_TOP': ['Pantheon', 'Darius', 'Fiora', 'Tryndamere'],
    'Heimerdinger_TOP': ['Ryze', 'Aurora', 'Yasuo', 'Varus'],
    'Irelia_TOP': ['Pantheon', 'Renekton', 'Jax', 'Fiora'],
    'Jax_TOP': ['Garen', 'Teemo', 'Pantheon', 'Sett'],
    'Jayce_TOP': ['Malphite', 'Pantheon', 'Irelia', 'Fiora'],
    "K'Sante_TOP": ['Garen', 'Rumble', 'Fiora', 'Kayle'],
    'Kayle_TOP': ['Pantheon', 'Renekton', 'Fiora', 'Tryndamere'],
    'Kennen_TOP': ['Malphite', 'Nasus', 'Dr.Mundo', 'Galio'],
    'Malphite_TOP': ['Singed', 'Ornn', 'Dr.Mundo', 'Sion'],
    'Mordekaiser_TOP': ['Fiora', 'Olaf', 'Darius', 'Tryndamere'],
    'Nasus_TOP': ['Garen', 'Renekton', "K'Sante", 'Fiora'],
    'Ornn_TOP': ['Singed', 'Garen', 'Darius', 'Olaf'],
    'Poppy_TOP': ['Darius', 'Renekton', 'Sett', 'Fiora'],
    'Renekton_TOP': ['Shen', 'Garen', "K'Sante", 'Pantheon'],
    'Riven_TOP': ['Renekton', 'Poppy', 'Kennen', 'Garen'],
    'Rumble_TOP':['Galio', 'Ryze', 'Aurora', 'Kayle'],
    'Sett_TOP': ['Pantheon', 'Darius', 'Vayne', 'Singed'],
    'Shen_TOP': ['Darius', 'Mordekaiser', 'Sett', 'Teemo'],
    'Singed_TOP': ['Vayne', 'Jayce', 'Nasus', 'Ryze'],
    'Sion_TOP': ['Darius', 'Shen', 'Singed', 'Irelia'],
    'Skarner_TOP': ['Shen', 'Fiora', 'Sion', 'Jax'],
    'Teemo_TOP': ['Rumble', 'Akali', 'Ryze', 'Olaf'],
    'Tryndamere_TOP': ['Malphite', 'Teemo', 'Jax', 'Volibear'],
    'Urgot_TOP': ['Olaf', 'Kayle', 'Sion', 'Tryndamere'],
    'Varus_TOP': ['Olaf', 'Yasuo', 'Irelia', 'Nasus'],
    'Vayne_TOP': ['Teemo', 'Malphite', 'Pantheon', 'Irelia'],
    'Volibear_TOP': ['Jax', 'Fiora', 'Teemo', 'Urgot'],
    'Wukong_TOP': ['Mordekaiser', 'Ornn', 'Poppy', 'Sett'],

    // JG
    'Ambessa_JG': ["Kha'Zix", 'Zed', 'Shyvana', 'Evelynn'],
    'Amumu_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Diana_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Ekko_JG': ["Lee'Sin", "Xin'Zhao", "Jarvan'IV", 'Graves'],
    'Evelynn_JG': ["Lee'Sin", 'Rengar', "Kha'Zix", 'Warwick'],
    'Fiddlesticks_JG': ["Xin'Zhao", 'Shyvana', "Jarvan'IV", 'Nocturne'],
    'Gragas_JG': ["Lee'Sin", "Xin'Zhao", "Jarvan'IV", 'Graves'],
    'Graves_JG': ["Xin'Zhao", "Lee'Sin", "Jarvan'IV", 'Vi'],
    'Hecarim_JG': ['Amumu', "Kha'Zix", 'Talon', 'Zed'],
    "Jarvan'IV_JG": ["Lee'Sin", "Xin'Zhao", 'Vi', 'Graves'],
    'Kindred_JG': ["Lee'Sin", 'Rammus', "Kha'Zix", 'Nidalee'],
    "Kha'Zix_JG": ["Lee'Sin", 'Rengar', "Xin'Zhao", 'Warwick'],
    "Lee'Sin_JG": ["Xin'Zhao", "Jarvan'IV", 'Vi', 'Graves'],
    'Lillia_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Maokai_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Master Yi_JG': ['Rammus', 'Amumu', 'Jax', 'Warwick'],
    'Nidalee_JG': ['Diana', 'Evelynn', "Kha'Zix", 'Warwick'],
    'Nocturne_JG': ['Rammus', 'Warwick', 'Evelynn', 'Lillia'],
    'Nunu y Willump_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Olaf_JG': ["Lee'Sin", "Xin'Zhao", "Jarvan'IV", 'Graves'],
    'Pantheon_JG': ["Lee'Sin", "Xin'Zhao", "Jarvan'IV", 'Vi'],
    'Poppy_JG': ["Lee'Sin", "Xin'Zhao", "Jarvan'IV", 'Graves'],
    'Rammus_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Rengar_JG': ["Lee'Sin", "Xin'Zhao", 'Warwick', 'Graves'],
    'Shen_JG': ['Nocturne', 'Viego', 'Lillia', 'Olaf'],
    'Shyvana_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Skarner_JG': ['Lillia', 'Rammus', 'Kayn', 'Shyvana'],
    'Taliyah_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    'Talon_JG': ["Lee'Sin", "Xin'Zhao", 'Warwick', 'Graves'],
    'Vi_JG': ["Lee'Sin", "Xin'Zhao", "Jarvan'IV", 'Graves'],
    'Viego_JG': ['Rammus', 'Olaf', 'Taliyah', 'Amumu'],
    'Warwick_JG': ["Lee'Sin", "Xin'Zhao", 'Graves', 'Olaf'],
    "Xin'Zhao_JG": ["Lee'Sin", "Jarvan'IV", 'Vi', 'Graves'],
    'Zed_JG': ["Lee'Sin", "Xin'Zhao", 'Warwick', 'Graves'],

    // MID
    'Ahri_MID': ['Mel', 'Galio', 'Zed', 'Brand'],
    'Aurora_MID': ['Diana', 'Katarina', 'Galio', 'Syndra'],
    'Akali_MID': ["Vex", 'Galio', "Twisted'Fate", 'Lissandra'],
    'Akshan_MID': ['Annie', 'Diana', 'Vladimir', 'Irelia'],
    'Annie_MID': ["Aurelion'Sol", 'Veigar', 'Syndra', 'Diana'],
    "Aurelion'Sol_MID": ['Yone', 'Irelia', 'Akshan', 'Zed'],
    'Brand_MID': ["Zed", 'Fizz', 'Syndra', 'Katarina'],
    'Ekko_MID': ['Talon', 'Vex', 'Lissandra', 'Zoe'],
    'Fizz_MID': ['Vladimir', 'Lissandra', 'Vex', 'Kassadin'],
    'Galio_MID': ['Swain', 'Zed', 'Ahri', 'Talon'],
    'Heimerdinger_MID': ['Lissandra', 'Ryze', 'Orianna', "Twisted'Fate"],
    'Irelia_MID': ['Vex', 'Talon', 'Ekko', 'Zoe'],
    'Karma_MID': ['Ryze', 'Brand', 'Viktor', 'Akali'],
    'Kassadin_MID': ['Zed', 'Talon', 'Yasuo', 'Yone'],
    'Lissandra_MID': ['Aurora', "Vel'Koz", 'Syndra', 'Lux'],
    'Lucian_MID': ['Annie', 'Zoe', 'Akshan', 'Zed'],
    'Lux_MID': ['Taliyah', 'Zed', 'Katarina', 'Fizz'],
    'Mel_MID': ['Akali', 'Zed', 'Diana', 'Ryze'],
    'Morgana_MID': ['Akshan', 'Zed', "Aurelion'Sol", 'Mel'],
    'Norra_MID': ['Ekko', 'Zoe', 'Ahri', 'Kassadin'],
    'Orianna_MID': ['Ekko', "Vel'Koz", 'Zoe', 'Diana'],
    'Syndra_MID': ["Vel'Koz", 'Zed', 'Katarina', 'Diana'],
    'Swain_MID': ['Katarina', "Aurelion'Sol", 'Syndra', "Vel'Koz"],
    'Taliyah_MID': ['Katarina', 'Kassadin', 'Brand', "Twisted'Fate"],
    'Talon_MID': ['Akshan', 'Taliyah', 'Diana', 'Akali'],
    "Twisted'Fate_MID": ['Fizz', 'Zed', 'Irelia', 'Veigar'],
    'Veigar_MID': ['Zed', 'Vladimir', 'Lux', 'Katarina'],
    "Vel'Koz_MID": ['Kassadin', 'Ekko', 'Fizz', 'Akali'],
    'Vex_MID': ['Mel', 'Brand', 'Annie', 'Kassadin'],
    'Viktor_MID': ['Talon', 'Ekko', 'Zoe', 'Syndra'],
    'Vladimir_MID': ['Orianna', 'Zoe', "Vel'Koz", 'Irelia'],
    'Yasuo_MID': ['Lissandra', 'Vex', 'Irelia', "Aurelion'Sol"],
    'Yone_MID': ['Annie', 'Vex', 'Lissandra', 'Akshan'],
    'Zed_MID': ['Lissandra', 'Ekko', 'Diana', 'Irelia'],
    'Ziggs_MID': ['Aurora', 'Annie', 'Brand', 'Vex'],
    'Zoe_MID': ['Akshan', 'Katarina', 'Talon', 'Taliyah'],

    // ADC
    'Ashe_ADC': ['Tristana', 'Draven', 'Jhin', 'Samira'],
    'Caitlyn_ADC': ['Draven', 'Samira', 'Xayah', 'Varus'],
    'Corki_ADC': ['Nilah', 'Varus', 'Caitlyn', 'Tristana'],
    'Draven_ADC': ['Vel Koz', 'Swain', 'Varus', 'Xayah'],
    'Ezreal_ADC': ["Kog'Maw", 'Draven', 'Zeri', 'Varus'],
    'Jhin_ADC': ['Draven', 'Samira', 'Tristana', 'Kalista'],
    'Jinx_ADC': ['Nilah', 'Draven', 'Kalista', 'Corki'],
    'Kalista_ADC': ['Varus', 'Mel', 'Corki', 'Sivir'],
    "Kai'Sa_ADC": ['Nilah', 'Draven', 'Varus', 'Samira'],
    "Kog'Maw_ADC": ['Corki', 'Draven', 'Nilah', 'Kalista'],
    'Lucian_ADC': ['Corki', 'Draven', 'Lux', 'Samira'],
    'Miss Fortune_ADC': ["Kog'Maw", 'Samira', 'Draven', 'Zeri'],
    'Nilah_ADC': ['Kalista', 'Xayah', 'Swain', 'Varus'],
    'Samira_ADC': ['Caitlyn', 'Ashe', 'Lucian', 'Jinx'],
    'Smolder_ADC': ["kog'Maw", 'Draven', 'Kalista', 'Tristana'],
    'Sivir_ADC': ['Tristana', 'Twitch', 'Draven', 'Mel'],
    'Tristana_ADC': ['Draven', 'Lucian', 'Mel', 'Samira'],
    'Twitch_ADC': ['Nilah', 'Zeri', 'Draven', 'Kalista'],
    'Varus_ADC': ["Kog'Maw", 'Draven', 'Mel', 'Samira'],
    'Vayne_ADC': ['Caitlyn', 'Senna', 'Zeri', 'Draven'],
    'Xayah_ADC': ['Ashe', 'Draven', 'Kalista', 'Tristana'],
    'Zeri_ADC': ['Lucian', 'Draven', "Kog'Maw", 'Ashe'],
    'Ziggs_ADC': ['Lucian', "Kog'Maw", 'Draven', 'Nilah'],

    // SUPP
    'Alistar_SUPP': ['Galio', 'Janna', 'Morgana', 'Soraka'],
    'Bardo_SUPP': ['Maokai', 'Thresh', 'Senna', 'Pyke'],
    'Blitzcrank_SUPP': ['Leona', 'Swain', 'Maokai', 'Zilean'],
    'Braum_SUPP': ['Zilean', 'Senna', 'Zyra', 'Maokai'],
    'Janna_SUPP': ['Senna', "Vel'Koz", 'Maokai', 'Blitzcrank'],
    'Leona_SUPP': ['Maokai', 'Thresh', 'Rell', 'Soraka'],
    'Lulu_SUPP': ['Rell', 'Leona', 'Thresh', 'Rakan'],
    'Lux_SUPP': ["Vel'Koz", 'Janna', 'Blitzcrank', 'Pyke'],
    'Nami_SUPP': ['Blitzcrank', 'Rell', 'Leona', 'Nautilus'],
    'Nautilus_SUPP': ['Braum', 'Rell', 'Thresh', 'Zilean'],
    'Rell_SUPP': ['Soraka', 'Zilean', 'Senna', 'Seraphine'],
    'Pyke_SUPP': ['Maokai', 'Rakan', 'Nautilus', 'Soraka'],
    'Rakan_SUPP': ['Maokai', 'Janna', 'Leona', 'Galio'],
    'Seraphine_SUPP': ['Maokai', 'Zilean', 'Bardo', 'Milio'],
    'Sona_SUPP': ['Leona', 'Thresh', 'Rakan', 'Pyke'],
    'Soraka_SUPP': ['Maokai', 'Seraphine', 'Senna', 'Zilean'],
    'Thresh_SUPP': ['Zyra', 'Seraphine', 'Rell', 'Zilean'],
    'Yuumi_SUPP': ['Rell', 'Rakan', 'Nautilus', 'Leona'],
    'Annie_SUPP': ['Galio', 'Maokai', 'Alistar', 'Pyke'],
    'Brand_SUPP': ['Zilean', 'Sona', 'Maokai', 'Nautilus'],
    'Galio_SUPP': ['Milio', 'Maokai', 'Rell', 'Sona'],
    'Karma_SUPP': ['Maokai', 'Zilean', 'Sona', 'Senna'],
    'Maokai_SUPP': ['Morgana', 'Sona', 'Yuumi', 'Thresh'],
    'Milio_SUPP': ['Braum', 'Sona', 'Thresh', 'Bardo'],
    'Morgana_SUPP': ['Lux', 'Senna', 'Rell', 'Sona'],
    'Shen_SUPP': ['Janna', 'Rakan', 'Sona', 'Seraphine'],
    'Senna_SUPP': ['Seraphine', 'Veigar', 'Swain', 'Lux'],
    'Swain_SUPP': ['Zilean', "Vel'Koz", 'Yuumi', 'Zyra'],
    'Veigar_SUPP': ['Maokai', 'Brand', 'Thresh', 'Leona'],
    "Vel'Koz_SUPP": ['Soraka', 'Nami', 'Rakan', 'Nautilus'],
    'Zilean_SUPP': ['Galio', 'Maokai', 'Janna', 'Pyke'],
    'Zyra_SUPP': ["Vel'Koz", 'Alistar', 'Leona', 'Blitzcrank'],
  };

  /// Verifica si un campeón por nombre ya está seleccionado
  bool isChampionSelectedByName(String name) {
    bool isAlly = alliedPicks.any((c) => c.name == name);
    bool isEnemy = enemyPicks.any((c) => c.name == name);
    return isAlly || isEnemy;
  }

    /// Obtiene recomendaciones de counter para los enemigos seleccionados
  List<Champion> obtenerCountersPorRol(
    String rolJugador, {
    Map<String, Champion>? inferredEnemyRoles,
  }) {
    if (enemyPicks.isEmpty) return [];

    Set<String> nombresCounters = {};

    for (var enemigo in enemyPicks) {
      // Determinar el rol real: usar inferencia si está disponible
            String rolEnemigo = enemigo.primaryRole; // fallback
      if (inferredEnemyRoles != null && inferredEnemyRoles.isNotEmpty) {
        for (final entry in inferredEnemyRoles.entries) {
          if (entry.value.name == enemigo.name) {
            rolEnemigo = entry.key;
            break;
          }
        }
      }
      // Construir la clave con el rol correcto
      String claveConRol = '${enemigo.name}_$rolEnemigo';

      if (_countersMap.containsKey(claveConRol)) {
        for (var counterNombre in _countersMap[claveConRol]!) {
          if (!isChampionSelectedByName(counterNombre)) {
            nombresCounters.add(counterNombre);
          }
        }
      } else if (_countersMap.containsKey(enemigo.name)) {

        // Fallback: clave sin rol (por si algún campeón no tiene variante por rol)
        for (var counterNombre in _countersMap[enemigo.name]!) {
          if (!isChampionSelectedByName(counterNombre)) {
            nombresCounters.add(counterNombre);
          }
        }
      }
    }
  
    
    List<Champion> recomendaciones = [];
    
    for (var nombre in nombresCounters) {
      for (var campeon in allChampions) {
        if (campeon.name == nombre && 
            campeon.roles.contains(rolJugador) &&
            !recomendaciones.contains(campeon)) {
          recomendaciones.add(campeon);
        }
      }
    }
    
    if (recomendaciones.length > 4) {
      recomendaciones = recomendaciones.sublist(0, 4);
    }
    
    return recomendaciones;
  }
}