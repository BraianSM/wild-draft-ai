// MODELO: Representa un campeón en nuestro draft
// Ahora incluye nombre, rol, imagen y atributos estratégicos

class Champion {
  final String name;
  final List<String> roles;
  final String imageUrl;

  // Atributos estratégicos (todos opcionales, por defecto false)
  final bool isAD;
  final bool isAP;
  final bool isTank;
  final bool hasCC;
  final bool hasEngage;
  final bool hasHealing;
  final bool usesAutoAttacks;
  final bool isMelee;
  final bool isEarlyGame;
  final bool isMidGame;
  final bool scalesLateGame;
  final bool hasShield;
  final bool hasDash;

  Champion({
    required this.name,
    required this.roles,
    required this.imageUrl,
    this.isAD = false,
    this.isAP = false,
    this.isTank = false,
    this.hasCC = false,
    this.hasEngage = false,
    this.hasHealing = false,
    this.usesAutoAttacks = false,
    this.isMelee = false,
    this.isEarlyGame = false,
    this.isMidGame = false,
    this.scalesLateGame = false,
    this.hasShield = false,
    this.hasDash = false
  });

  // Método para obtener las iniciales (primeras 2 letras en mayúscula)
  String get initials {
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.toUpperCase();
  }

  // Método para obtener el rol principal (el primero de la lista)
  String get primaryRole {
    if (roles.isNotEmpty) {
      return roles[0];
    }
    return 'FLEX';
  }
}