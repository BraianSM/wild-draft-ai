// lib/services/role_inference_service.dart
import '../models/champion.dart';

/// Servicio que infiere la posición más probable de cada campeón enemigo
class RoleInferenceService { 

  /// Retorna un mapa con la asignación de roles inferida.
  /// Si no se puede asignar un rol, simplemente no aparecerá en el mapa.
  Map<String, Champion> inferEnemyRoles(List<Champion> enemies) {
    if (enemies.isEmpty) return {};
    
    // 1. Separar campeones fijos (un solo rol) y flexibles.
    final List<Champion> fixed = [];
    final List<Champion> flexible = [];

    for (final champ in enemies) {
      if (champ.roles.length == 1) {
        fixed.add(champ);
      } else {
        flexible.add(champ);
      }
    }

    // 2. Ordenar flexibles por cantidad de roles posibles (menos primero).
    //    Así los que tienen 2 roles se asignan antes que los que tienen 3+,
    //    reduciendo las posibilidades de conflicto.
    flexible.sort((a, b) => a.roles.length.compareTo(b.roles.length));

    // 3. Intentar asignar con backtracking.
    return _backtrack(fixed, flexible, 0, <String, Champion>{});
  }

  /// Algoritmo recursivo que asigna campeones flexibles a roles libres.
  Map<String, Champion> _backtrack(
    List<Champion> fixed,
    List<Champion> flexible,
    int index,
    Map<String, Champion> current,
  ) {
    // Si ya procesamos todos los flexibles, asignar los fijos.
    if (index == flexible.length) {
      final result = Map<String, Champion>.from(current);
      for (final champ in fixed) {
        final role = champ.roles.first;
        if (!result.containsKey(role)) {
          result[role] = champ;
        } else {
          // Conflicto: dos campeones fijos con el mismo rol.
          // Esto no debería ocurrir con datos correctos.
          return {};
        }
      }
      return result;
    }

    final champ = flexible[index];

    // Roles aún no ocupados que este campeón puede desempeñar.
    final availableRoles = champ.roles.where((r) => !current.containsKey(r)).toList();

    for (final role in availableRoles) {
      current[role] = champ;
      final result = _backtrack(fixed, flexible, index + 1, current);
      if (result.isNotEmpty) return result; // Asignación exitosa.
      current.remove(role); // Backtrack.
    }

    // No se encontró asignación válida para este campeón.
    return {};
  }
}