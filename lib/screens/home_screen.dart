// PANTALLA PRINCIPAL: Con selector de modo Aliado/Enemigo
// Y selector de rol del jugador para recomendaciones filtradas

import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../data/champions_data.dart';
import '../services/draft_service.dart';
import '../services/counter_service.dart';
import '../services/composition_service.dart';
import '../widgets/champion_card.dart';
import '../widgets/team_panel_widget.dart';
import '../theme/app_colors.dart';
import '../services/role_inference_service.dart';
import '../services/favorites_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final DraftService _draftService = DraftService();
  final List<Champion> _allChampions = ChampionsData.getAll();
  late CounterService _counterService;
  final CompositionService _compositionService = CompositionService();

  final TextEditingController _searchController = TextEditingController();

  List<Champion> _filteredChampions = [];

  final List<String> _roleOrder = ['TOP', 'JG', 'MID', 'ADC', 'SUPP'];

  String _modoActual = 'aliado';
  String _selectedRole = 'TOP';
  String? _roleFilter;
  bool _showFavoritesOnly = false;

  late AnimationController _glowController;
  final FavoritesService _favoritesService = FavoritesService();

  void _actualizarCounterService() {
    _counterService = CounterService(
      alliedPicks: _draftService.alliedPicks,
      enemyPicks: _draftService.enemyPicks,
      allChampions: _allChampions,
    );
  }

  @override
  void initState() {
    super.initState();
    _applyFilters();
    _searchController.addListener(_onSearchChanged);
    _actualizarCounterService();

    _favoritesService.init().then((_) {
    if (mounted) setState(() {});
    });

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

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      _filteredChampions = _allChampions.where((champion) {
        bool matchesSearch = query.isEmpty || champion.name.toLowerCase().contains(query);
        bool matchesRole = _roleFilter == null || champion.roles.contains(_roleFilter);
        bool matchesFavorites = !_showFavoritesOnly || _favoritesService.isFavorite(champion.name);
        return matchesSearch && matchesRole && matchesFavorites;
      }).toList();
    });
  }

  void _updateUI() {
    _actualizarCounterService();
    setState(() {});
  }

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
      case 'TOP':
        return Icons.shield;
      case 'JG':
        return Icons.forest;
      case 'MID':
        return Icons.auto_awesome;
      case 'ADC':
        return Icons.gps_fixed;
      case 'SUPP':
        return Icons.favorite;
      default:
        return Icons.star;
    }
  }

  /// Muestra un Modal Bottom Sheet con el análisis completo de composición del equipo
  void _showCompositionDetails(String teamTitle, Map<String, int> attributes, int teamSize, Color accentColor) {
    final allDefs = CompositionService.allDefinitions;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.analytics, color: accentColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Análisis de $teamTitle',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$teamSize campeones',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: allDefs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final def = allDefs[index];
                    final count = attributes[def.key] ?? 0;
                    final ratio = teamSize > 0 ? count / teamSize : 0.0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(def.icon, size: 18, color: def.color),
                            const SizedBox(width: 10),
                            Text(
                              def.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: def.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            backgroundColor: AppColors.borderDark.withValues(alpha: 0.4),
                            valueColor: AlwaysStoppedAnimation<Color>(def.color.withValues(alpha: 0.8)),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final championsByRole = _getChampionsByRole();
    final roleInference = RoleInferenceService();
    final inferredEnemyRoles = roleInference.inferEnemyRoles(_draftService.enemyPicks);
    final recomendaciones = _counterService.obtenerCountersPorRol(
     _selectedRole,
     inferredEnemyRoles: inferredEnemyRoles,
    );
    final alliedAttributes = _compositionService.analyze(_draftService.alliedPicks);
    final enemyAttributes = _compositionService.analyze(_draftService.enemyPicks);
    final alliedVisible = _compositionService.getDefinitionsForDisplay(extended: false);
    final enemyVisible = _compositionService.getDefinitionsForDisplay(extended: true);

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

          // CONTENIDO PRINCIPAL CON SCROLL
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 12),

                // SECCIÓN: Equipo aliado (azul)
                TeamPanelWidget(
                  title: 'ALIADOS',
                  picks: _draftService.alliedPicks,
                  color: AppColors.allyBlue,
                  glowColor: AppColors.allyBlueGlow,
                  attributes: alliedAttributes,
                  visibleAttributes: alliedVisible,
                  onAttributeTap: () => _showCompositionDetails(
                    'ALIADOS', alliedAttributes, _draftService.alliedPicks.length, AppColors.allyBlue,
                  ),
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
                TeamPanelWidget(
                  title: 'ENEMIGOS',
                  picks: _draftService.enemyPicks,
                  color: AppColors.enemyRed,
                  glowColor: AppColors.enemyRedGlow,
                  attributes: enemyAttributes,
                  visibleAttributes: enemyVisible,
                  onAttributeTap: () => _showCompositionDetails(
                    'ENEMIGOS', enemyAttributes, _draftService.enemyPicks.length, AppColors.enemyRed,
                  ),
                  onRemovePick: (index) {
                    _draftService.removeEnemyPick(index);
                    _updateUI();
                  },
                ),

                // ** NUEVO: ADVERTENCIAS DE COMPOSICIÓN ENEMIGA **
                if (_draftService.enemyPicks.isNotEmpty)
                  _buildCompositionWarnings(),

                // ** NUEVO: RECOMENDACIONES ESTRATÉGICAS **
                if (_draftService.enemyPicks.isNotEmpty)
                  _buildStrategicRecommendations(),

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

                // FILTRO RÁPIDO DE ROL
                _buildRoleQuickFilter(),

                const SizedBox(height: 15),

                // GRID CON SEPARACIÓN POR ROLES (SCROLL INTERNO DESHABILITADO)
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    if (_roleFilter != null && _filteredChampions.isNotEmpty)
                      _buildRoleGrid(_filteredChampions)
                    else
                      for (var entry in championsByRole.entries)
                        _buildRoleSection(
                          role: entry.key,
                          champions: entry.value,
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ** NUEVO: Widget para mostrar advertencias de composición enemiga **
  Widget _buildCompositionWarnings() {
    final warnings = _compositionService.getCompositionWarnings(_draftService.enemyPicks);

    if (warnings.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.enemyRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.enemyRed.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.enemyRed, size: 14),
                const SizedBox(width: 4),
                Text(
                  'ALERTAS DE COMPOSICIÓN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.enemyRed,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...warnings.map((w) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Icon(w.icon, size: 12, color: w.color),
                  const SizedBox(width: 4),
                  Text(
                    '${w.message} (${w.count}/${w.threshold})',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  /// ** NUEVO: Widget para mostrar recomendaciones estratégicas basadas en advertencias **
  Widget _buildStrategicRecommendations() {
    // Usamos el nuevo método basado en la composición enemiga completa
    final recommendations = _compositionService.getStrategicRecommendations(
      _draftService.enemyPicks,
      _selectedRole,
      _allChampions,
      alliedPicks: _draftService.alliedPicks,
    );

    if (recommendations.isEmpty) return const SizedBox.shrink();

    // Agrupar recomendaciones por advertencia para mostrarlas organizadas
    final Map<String, List<StrategicRecommendation>> grouped = {};
    for (final rec in recommendations) {
      grouped.putIfAbsent(rec.warningKey, () => []).add(rec);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.selectedPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.selectedPurple.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: AppColors.selectedPurple, size: 14),
                const SizedBox(width: 4),
                Text(
                  'RECOMENDACION ESTRATEGICA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.selectedPurple,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...grouped.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado de la advertencia
                    Row(
                      children: [
                        Icon(entry.value.first.icon, size: 12, color: entry.value.first.color),
                        const SizedBox(width: 4),
                        Text(
                          'Para contrarrestar:',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: entry.value.first.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Recomendaciones individuales
                    ...entry.value.map((rec) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_forward_ios, size: 8, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${rec.championName}: ',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accentGold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: rec.reason,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


    /// Filtro rápido por rol (botones pequeños arriba de la lista de campeones)
  Widget _buildRoleQuickFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Botones de rol existentes
            ..._roleOrder.map((rol) {
              bool isSelected = _roleFilter == rol;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_roleFilter == rol) {
                      _roleFilter = null;
                    } else {
                      _roleFilter = rol;
                    }
                  });
                  _applyFilters();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.getRoleColor(rol).withValues(alpha: 0.2)
                        : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.getRoleColor(rol)
                          : AppColors.borderDark.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    rol,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppColors.getRoleColor(rol)
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }),
            // Botón de Favoritos ⭐
            GestureDetector(
              onTap: () {
                setState(() {
                  _showFavoritesOnly = !_showFavoritesOnly;
                });
                _applyFilters();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _showFavoritesOnly
                      ? AppColors.accentGold.withValues(alpha: 0.2)
                      : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _showFavoritesOnly
                        ? AppColors.accentGold
                        : AppColors.borderDark.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showFavoritesOnly ? Icons.star : Icons.star_border,
                      size: 12,
                      color: _showFavoritesOnly
                          ? AppColors.accentGold
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Favoritos',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: _showFavoritesOnly ? FontWeight.bold : FontWeight.w500,
                        color: _showFavoritesOnly
                            ? AppColors.accentGold
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Grid simple sin título para cuando se filtra por rol
  Widget _buildRoleGrid(List<Champion> champions) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
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
          isFavorite: _favoritesService.isFavorite(champion.name),
          onDoubleTap: () {
            _favoritesService.toggleFavorite(champion.name).then((_) {
              setState(() {});
            });
          },
        );
      }
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
            Row(
              children: [
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
                'COUNTER DIRECTO DEL $_selectedRole',
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
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
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
              isFavorite: _favoritesService.isFavorite(champion.name),
              onDoubleTap: () {
                _favoritesService.toggleFavorite(champion.name).then((_) {
                  setState(() {});
                });
              }
            );
          },
        ),
        const SizedBox(height: 1),
      ],
    );
  }
}