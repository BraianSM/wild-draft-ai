import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_champions';
  SharedPreferences? _prefs;
  final Set<String> _favorites = {};

  /// Inicializa el servicio (cargar favoritos guardados).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final list = _prefs?.getStringList(_key) ?? [];
    _favorites.addAll(list);
  }

  /// Verifica si un campeón es favorito.
  bool isFavorite(String championName) => _favorites.contains(championName);

  /// Alterna el estado de favorito y persiste el cambio.
  Future<void> toggleFavorite(String championName) async {
    if (_favorites.contains(championName)) {
      _favorites.remove(championName);
    } else {
      _favorites.add(championName);
    }
    if (_prefs != null) {
    await _prefs?.setStringList(_key, _favorites.toList());
    }
  }
}
