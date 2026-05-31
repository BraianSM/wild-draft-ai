// WIDGET: Panel reutilizable para mostrar equipo (Aliados o Enemigos)
// Incluye slots de campeones y chips de atributos interactivos

import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../services/composition_service.dart';
import '../theme/app_colors.dart';

class TeamPanelWidget extends StatelessWidget {
  final String title;
  final List<Champion> picks;
  final Color color;
  final Color glowColor;
  final Map<String, int> attributes;
  final List<AttributeDef> visibleAttributes;
  final VoidCallback? onAttributeTap;
  final Function(int) onRemovePick;

  const TeamPanelWidget({
    super.key,
    required this.title,
    required this.picks,
    required this.color,
    required this.glowColor,
    required this.attributes,
    required this.visibleAttributes,
    this.onAttributeTap,
    required this.onRemovePick,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel izquierdo: título y slots
          Expanded(
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
                // Slots de campeones
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
          ),
          const SizedBox(width: 8),
          // Panel derecho: atributos compactos e interactivos
          SizedBox(
            width: 80,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: visibleAttributes.map((def) {
                final count = attributes[def.key] ?? 0;
                return GestureDetector(
                  onTap: onAttributeTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: def.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: def.color.withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(def.icon, size: 10, color: def.color),
                        const SizedBox(width: 2),
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: def.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}