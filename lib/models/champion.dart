// MODELO: Representa un campeón en nuestro draft
// Ahora incluye nombre, rol e imagen

class Champion {
  final String name;
  final List<String> roles; // Rol del campeón: Asesino, Luchador, Mago, etc.
  final String imageUrl; // URL exacta de la imagen en Data Dragon

  // Constructor con todos los campos
  Champion({
    required this.name,
    required this.roles,
    required this.imageUrl,
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