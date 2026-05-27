// PANTALLA PRINCIPAL: Con selector de modo Aliado/Enemigo
// Y selector de rol del jugador para recomendaciones filtradas

import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../data/champions_data.dart';
import '../services/draft_service.dart';
import '../widgets/champion_card.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final DraftService _draftService = DraftService();
  final List<Champion> _allChampions = ChampionsData.getAll();
  
  // Controlador para el texto de búsqueda
  final TextEditingController _searchController = TextEditingController();
  
  // Lista filtrada de campeones (según búsqueda)
  List<Champion> _filteredChampions = [];

  // Lista de roles disponibles en orden
  final List<String> _roleOrder = ['TOP', 'JG', 'MID', 'ADC', 'SUPP'];

  // MODO ACTUAL: 'aliado' o 'enemigo'
  String _modoActual = 'aliado';

  // ROL SELECCIONADO del jugador
  String _selectedRole = 'TOP';

  // Controlador de animación para el glow del fondo
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _filteredChampions = _allChampions;
    _searchController.addListener(_filterChampions);
    
    // Animación suave para el glow ambiental
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _glowController.dispose();
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
    final recomendaciones = _draftService.obtenerCountersPorRol(_selectedRole);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.diamond, color: AppColors.accentGold, size: 22),
            const SizedBox(width: 8),
            Text(
              'Wild Draft AI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: 2.0,
                shadows: [
                  Shadow(
                    color: AppColors.accentGold.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.surfaceDark.withValues(alpha: 0.9),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGold.withValues(alpha: 0.3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.accentGold, size: 20),
              tooltip: 'Reiniciar draft',
              onPressed: () {
                _draftService.resetDraft();
                _updateUI();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // FONDO CON GRADIENTE Y GLOW AMBIENTAL
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.backgroundDark,
                        const Color(0xFF0D1321),
                        const Color(0xFF0F172A),
                        AppColors.backgroundDark,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Glow azul izquierda (aliados)
                      Positioned(
                        left: -100,
                        top: 0,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.allyBlue.withValues(alpha: 0.08 * _glowController.value + 0.04),
                                AppColors.allyBlue.withValues(alpha: 0.02),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Glow rojo derecha (enemigos)
                      Positioned(
                        right: -100,
                        top: 0,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.enemyRed.withValues(alpha: 0.08 * _glowController.value + 0.04),
                                AppColors.enemyRed.withValues(alpha: 0.02),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // CONTENIDO PRINCIPAL
          Column(
            children: [
              SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 12),

              // SECCIÓN: Equipo aliado (azul)
              _buildTeamSection(
                title: 'ALIADOS',
                picks: _draftService.alliedPicks,
                color: AppColors.allyBlue,
                glowColor: AppColors.allyBlueGlow,
                onRemovePick: (index) {
                  _draftService.removeAllyPick(index);
                  _updateUI();
                },
              ),

              // Separador entre equipos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.accentGold.withValues(alpha: 0.4),
                        AppColors.accentGold.withValues(alpha: 0.6),
                        AppColors.accentGold.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // SECCIÓN: Equipo enemigo (rojo)
              _buildTeamSection(
                title: 'ENEMIGOS',
                picks: _draftService.enemyPicks,
                color: AppColors.enemyRed,
                glowColor: AppColors.enemyRedGlow,
                onRemovePick: (index) {
                  _draftService.removeEnemyPick(index);
                  _updateUI();
                },
              ),

              const SizedBox(height: 10),

              // SELECTOR DE ROL DEL JUGADOR
              _buildRoleSelector(),

              const SizedBox(height: 8),

              // TOGGLE ALIADO / ENEMIGO
              _buildModeToggle(),

              const SizedBox(height: 8),

              // BARRA DE BÚSQUEDA
              _buildSearchBar(),

              const SizedBox(height: 6),

              // Indicador de modo activo y contadores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      _modoActual == 'aliado' ? Icons.group_add : Icons.person_remove,
                      color: _modoActual == 'aliado' ? AppColors.allyBlue : AppColors.enemyRed,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tocando agrega a ${_modoActual == 'aliado' ? 'ALIADOS' : 'ENEMIGOS'}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _modoActual == 'aliado' 
                            ? AppColors.allyBlue.withValues(alpha: 0.8) 
                            : AppColors.enemyRed.withValues(alpha: 0.8),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'A: ${_draftService.alliedPicks.length}/5  E: ${_draftService.enemyPicks.length}/5',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // RECOMENDACIONES
              if (recomendaciones.isNotEmpty)
                _buildRecomendacionesSection(recomendaciones: recomendaciones),

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
        ],
      ),
    );
  }

  /// Construye la sección de un equipo (aliados o enemigos)
  Widget _buildTeamSection({
    required String title,
    required List<Champion> picks,
    required Color color,
    required Color glowColor,
    required Function(int) onRemovePick,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
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
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                picks[index].imageUrl,
                                height: 36,
                                width: 36,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 36,
                                    width: 36,
                                    color: AppColors.surfaceDark,
                                    child: const Center(
                                      child: SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: AppColors.accentGold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          color.withValues(alpha: 0.8),
                                          color.withValues(alpha: 0.4),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: color, width: 1.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        picks[index].initials,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: 36,
                          child: Text(
                            picks[index].name,
                            style: TextStyle(
                              fontSize: 7,
                              color: AppColors.textSecondary,
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
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.borderDark.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.question_mark,
                      size: 16,
                      color: AppColors.textMuted,
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

  /// Construye el selector de rol del jugador
  Widget _buildRoleSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRoleIcon(_selectedRole),
                color: AppColors.getRoleColor(_selectedRole),
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                'MI ROL: $_selectedRole',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getRoleColor(_selectedRole),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: _roleOrder.map((rol) {
              final isActive = _selectedRole == rol;
              final roleColor = AppColors.getRoleColor(rol);
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRole = rol;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? roleColor.withValues(alpha: 0.2) 
                          : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: isActive ? roleColor : AppColors.borderDark.withValues(alpha: 0.6),
                        width: isActive ? 1.5 : 1,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: roleColor.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getRoleIcon(rol),
                          color: isActive ? roleColor : AppColors.textMuted,
                          size: 16,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rol,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                            color: isActive ? roleColor : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Construye el toggle de modo aliado/enemigo
  Widget _buildModeToggle() {
    final bool isAlly = _modoActual == 'aliado';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderDark.withValues(alpha: 0.4),
          ),
        ),
        child: Stack(
          children: [
            // Fondo animado que se desliza
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isAlly ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.all(3),
                width: (MediaQuery.of(context).size.width - 28 - 6) / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isAlly
                        ? [AppColors.allyBlue, AppColors.allyBlue.withValues(alpha: 0.7)]
                        : [AppColors.enemyRed, AppColors.enemyRed.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: (isAlly ? AppColors.allyBlue : AppColors.enemyRed).withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            // Botones
            Row(
              children: [
                // ALIADO
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _modoActual = 'aliado'),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group_add,
                            color: isAlly ? Colors.white : AppColors.textMuted,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ALIADO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isAlly ? Colors.white : AppColors.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ENEMIGO
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _modoActual = 'enemigo'),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_remove,
                            color: !isAlly ? Colors.white : AppColors.textMuted,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ENEMIGO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: !isAlly ? Colors.white : AppColors.textMuted,
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
          ],
        ),
      ),
    );
  }

  /// Construye la barra de búsqueda
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 18),
            hintText: 'Buscar campeón...',
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
            filled: true,
            fillColor: AppColors.cardDark.withValues(alpha: 0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.accentGold, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      ),
    );
  }

  /// Construye la sección de recomendaciones de counters
  Widget _buildRecomendacionesSection({
    required List<Champion> recomendaciones,
  }) {
    if (recomendaciones.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates, color: AppColors.accentGold, size: 16),
              const SizedBox(width: 6),
              Text(
                'RECOMENDACIONES PARA $_selectedRole',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${recomendaciones.length}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recomendaciones.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final campeon = recomendaciones[index];
                return _buildRecomendacionCard(campeon);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Construye una card de recomendación individual
  Widget _buildRecomendacionCard(Champion campeon) {
    return GestureDetector(
      onTap: () => _seleccionarCampeon(campeon),
      child: Container(
        width: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.selectedPurple.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                campeon.imageUrl,
                height: 28,
                width: 28,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 28,
                    width: 28,
                    color: AppColors.surfaceDark,
                    child: const Center(
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.accentGold),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 28,
                    width: 28,
                    color: AppColors.surfaceDark,
                    child: Center(
                      child: Text(
                        campeon.initials,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 1),
            Text(
              campeon.name,
              style: const TextStyle(fontSize: 6, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye una sección de rol con su título y campeones
  Widget _buildRoleSection({
    required String role,
    required List<Champion> champions,
  }) {
    final roleColor = AppColors.getRoleColor(role);
    final roleIcon = _getRoleIcon(role);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TÍTULO DEL ROL
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            children: [
              Icon(roleIcon, color: roleColor, size: 16),
              const SizedBox(width: 5),
              Text(
                role,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.15),
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
              borderColor: _modoActual == 'aliado' 
                  ? AppColors.allyBlue.withValues(alpha: 0.6) 
                  : AppColors.enemyRed.withValues(alpha: 0.6),
              onTap: () => _seleccionarCampeon(champion),
            );
          },
        ),
        
        const SizedBox(height: 4),
      ],
    );
  }
}