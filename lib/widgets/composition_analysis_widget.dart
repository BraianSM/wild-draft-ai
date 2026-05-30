
import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../theme/app_colors.dart';

class CompositionAnalysisWidget extends StatelessWidget {
  final List<Champion> enemyTeam;

  const CompositionAnalysisWidget({
    super.key,
    required this.enemyTeam,
  });

  @override
  Widget build(BuildContext context) {
    if (enemyTeam.isEmpty) {
      return const SizedBox.shrink();
    }

    // Contar atributos
    int adCount = enemyTeam.where((c) => c.isAD).length;
    int apCount = enemyTeam.where((c) => c.isAP).length;
    int tankCount = enemyTeam.where((c) => c.isTank).length;
    int ccCount = enemyTeam.where((c) => c.hasCC).length;
    int engageCount = enemyTeam.where((c) => c.hasEngage).length;
    int healingCount = enemyTeam.where((c) => c.hasHealing).length;
    int lateGameCount = enemyTeam.where((c) => c.scalesLateGame).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              const Icon(Icons.analytics, color: AppColors.accentGold, size: 16),
              const SizedBox(width: 6),
              const Text(
                'ANÁLISIS DE COMPOSICIÓN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGold,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${enemyTeam.length} enemigos',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Indicadores
          _buildIndicator(
            icon: Icons.gps_fixed,
            label: 'Daño AD',
            count: adCount,
            total: enemyTeam.length,
            color: AppColors.enemyRed,
          ),
          _buildIndicator(
            icon: Icons.auto_awesome,
            label: 'Daño AP',
            count: apCount,
            total: enemyTeam.length,
            color: Colors.purpleAccent,
          ),
          _buildIndicator(
            icon: Icons.shield,
            label: 'Tanques',
            count: tankCount,
            total: enemyTeam.length,
            color: Colors.blueGrey,
          ),
          _buildIndicator(
            icon: Icons.link,
            label: 'CC',
            count: ccCount,
            total: enemyTeam.length,
            color: Colors.orange,
          ),
          _buildIndicator(
            icon: Icons.flash_on,
            label: 'Engage',
            count: engageCount,
            total: enemyTeam.length,
            color: Colors.yellowAccent,
          ),
          _buildIndicator(
            icon: Icons.healing,
            label: 'Curación',
            count: healingCount,
            total: enemyTeam.length,
            color: Colors.greenAccent,
          ),
          _buildIndicator(
            icon: Icons.trending_up,
            label: 'Escala Tardío',
            count: lateGameCount,
            total: enemyTeam.length,
            color: Colors.deepPurpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    double ratio = total > 0 ? count / total : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color.withValues(alpha: 0.9)),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: AppColors.borderDark.withValues(alpha: 0.4),
                valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.8)),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}