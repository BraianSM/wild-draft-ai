// PANTALLA PRINCIPAL: Con selector de modo Aliado/Enemigo
// Tocar un campeón lo agrega según el modo activo

import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../data/champions_data.dart';
import '../services/draft_service.dart';
import '../widgets/champion_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DraftService _draftService = DraftService();
  final List<Champion> _allChampions = ChampionsData.getAll();
  
  // Controlador para el texto de búsqueda
  final TextEditingController _searchController = TextEditingController();
  
  // Lista filtrada de campeones (según búsqueda)
  List<Champion> _filteredChampions = [];

  // Lista de roles disponibles en orden
  final List<String> _roleOrder = ['TOP', 'JG', 'MID', 'ADC', 'SUPP'];

  // MODO ACTUAL: 'aliado' o 'enemigo'
  String _modoActual = 'aliado'; // Por defecto: Aliado

  @override
  void initState() {
    super.initState();
    _filteredChampions = _allChampions;
    _searchController.addListener(_filterChampions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtra los campeones según el texto de búsqueda
  void _filterChampions() {
    final query = _searchController.text.toLowerCase().trim();
    
    setState(() {
      if (query.isEmpty) {
        _filteredChampions = _allChampions;
      } else {
        _filteredChampions = _allChampions
            .where((champion) => 
                champion.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _updateUI() {
    setState(() {});
  }

  /// Agrega un campeón según el modo actual
  void _seleccionarCampeon(Champion champion) {
    if (_draftService.isChampionSelected(champion)) return;
    
    if (_modoActual == 'aliado') {
      if (_draftService.alliedPicks.length < _draftService.maxPicks) {
        _draftService.pickAsAlly(champion);
      }
    } else {
      if (_draftService.enemyPicks.length < _draftService.maxPicks) {
        _draftService.pickAsEnemy(champion);
      }
    }
    _updateUI();
  }

  /// Obtiene los campeones filtrados agrupados por rol principal
  Map<String, List<Champion>> _getChampionsByRole() {
    Map<String, List<Champion>> rolesMap = {};
    
    for (var role in _roleOrder) {
      rolesMap[role] = [];
    }
    
    for (var champion in _filteredChampions) {
      final primaryRole = champion.primaryRole;
      if (rolesMap.containsKey(primaryRole)) {
        rolesMap[primaryRole]!.add(champion);
      } else {
        rolesMap[primaryRole] = [champion];
      }
    }
    
    rolesMap.removeWhere((key, value) => value.isEmpty);
    return rolesMap;
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'TOP': return Colors.orange;
      case 'JG': return Colors.green;
      case 'MID': return Colors.purple;
      case 'ADC': return Colors.amber;
      case 'SUPP': return Colors.teal;
      default: return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'TOP': return Icons.shield;
      case 'JG': return Icons.forest;
      case 'MID': return Icons.auto_awesome;
      case 'ADC': return Icons.gps_fixed;
      case 'SUPP': return Icons.favorite;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final championsByRole = _getChampionsByRole();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wild Draft AI'),
        centerTitle: true,
        backgroundColor: const Color(0xFF161B22),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.amber),
            tooltip: 'Reiniciar draft',
            onPressed: () {
              _draftService.resetDraft();
              _updateUI();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // SECCIÓN: Equipo aliado (azul)
          _buildTeamSection(
            title: 'ALIADOS',
            picks: _draftService.alliedPicks,
            color: Colors.blue,
            onRemovePick: (index) {
              _draftService.removeAllyPick(index);
              _updateUI();
            },
          ),

          // Separador entre equipos
          Container(
            height: 2,
            color: Colors.amber,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          // SECCIÓN: Equipo enemigo (rojo)
          _buildTeamSection(
            title: 'ENEMIGOS',
            picks: _draftService.enemyPicks,
            color: Colors.red,
            onRemovePick: (index) {
              _draftService.removeEnemyPick(index);
              _updateUI();
            },
          ),

          const SizedBox(height: 8),

          // SELECTOR DE MODO: ALIADO / ENEMIGO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Botón ALIADO
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _modoActual = 'aliado';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _modoActual == 'aliado' 
                              ? Colors.blue[700] 
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(11),
                            bottomLeft: Radius.circular(11),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_add,
                              color: _modoActual == 'aliado' 
                                  ? Colors.white 
                                  : Colors.blue[300],
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ALIADO',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _modoActual == 'aliado' 
                                    ? Colors.white 
                                    : Colors.blue[300],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Separador entre botones
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                  
                  // Botón ENEMIGO
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _modoActual = 'enemigo';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _modoActual == 'enemigo' 
                              ? Colors.red[700] 
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(11),
                            bottomRight: Radius.circular(11),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_remove,
                              color: _modoActual == 'enemigo' 
                                  ? Colors.white 
                                  : Colors.red[300],
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ENEMIGO',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _modoActual == 'enemigo' 
                                    ? Colors.white 
                                    : Colors.red[300],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // BARRA DE BÚSQUEDA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 20,
                ),
                hintText: 'Buscar campeón...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                filled: true,
                fillColor: const Color(0xFF21262D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.amber, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Indicador de modo activo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  _modoActual == 'aliado' ? Icons.group_add : Icons.person_remove,
                  color: _modoActual == 'aliado' ? Colors.blue : Colors.red,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Tocando agrega a ${_modoActual == 'aliado' ? 'ALIADOS' : 'ENEMIGOS'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: _modoActual == 'aliado' ? Colors.blue[300] : Colors.red[300],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Contadores
                Text(
                  'A: ${_draftService.alliedPicks.length}/5  E: ${_draftService.enemyPicks.length}/5',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // GRID CON SEPARACIÓN POR ROLES
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (var entry in championsByRole.entries)
                  _buildRoleSection(
                    role: entry.key,
                    champions: entry.value,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye una sección de rol con su título y campeones
  Widget _buildRoleSection({
    required String role,
    required List<Champion> champions,
  }) {
    final roleColor = _getRoleColor(role);
    final roleIcon = _getRoleIcon(role);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TÍTULO DEL ROL
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            children: [
              Icon(roleIcon, color: roleColor, size: 18),
              const SizedBox(width: 6),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${champions.length}',
                  style: TextStyle(
                    fontSize: 10,
                    color: roleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // GRID DE CAMPEONES
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: champions.length,
          itemBuilder: (context, index) {
            final champion = champions[index];
            final isSelected = _draftService.isChampionSelected(champion);

            return ChampionCard(
              champion: champion,
              isSelected: isSelected,
              // Color del borde según modo activo
              borderColor: _modoActual == 'aliado' 
                  ? Colors.blue.withValues(alpha: 0.5) 
                  : Colors.red.withValues(alpha: 0.5),
              onTap: () => _seleccionarCampeon(champion),
            );
          },
        ),
        
        const SizedBox(height: 4),
      ],
    );
  }

  /// Construye la sección de un equipo (aliados o enemigos)
  Widget _buildTeamSection({
    required String title,
    required List<Champion> picks,
    required Color color,
    required Function(int) onRemovePick,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      color: const Color(0xFF161B22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              if (index < picks.length) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: GestureDetector(
                    onTap: () => onRemovePick(index),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                picks[index].imageUrl,
                                height: 32,
                                width: 32,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 32,
                                    width: 32,
                                    color: Colors.grey[800],
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          color == Colors.blue
                                              ? Colors.blue[800]!
                                              : Colors.red[800]!,
                                          color == Colors.blue
                                              ? Colors.blue[900]!
                                              : Colors.red[900]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: color, width: 1.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        picks[index].initials,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        SizedBox(
                          width: 32,
                          child: Text(
                            picks[index].name,
                            style: const TextStyle(
                              fontSize: 7,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.question_mark,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}