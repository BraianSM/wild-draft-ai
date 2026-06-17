// WIDGET: Tarjeta individual para cada campeón en el grid

import 'package:flutter/material.dart';
import '../models/champion.dart';
import '../theme/app_colors.dart';

class ChampionCard extends StatelessWidget {
  final Champion champion;
  final bool isSelected;
  final Color borderColor;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onDoubleTap;

  const ChampionCard({
    super.key,
    required this.champion,
    required this.isSelected,
    required this.borderColor,
    required this.onTap,
    this.isFavorite = false,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: AnimatedScale(
        scale: isSelected ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Stack(
          children: [
            // Contenedor original
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [borderColor.withValues(alpha: 0.2), AppColors.cardDark]
                      : [AppColors.cardDark, AppColors.surfaceDark],
                ),
                border: Border.all(
                  color: isSelected
                      ? borderColor
                      : AppColors.borderDark.withValues(alpha: 0.5),
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? borderColor.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.3),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagen del campeón
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            champion.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.surfaceDark,
                                child: const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
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
                                color: AppColors.surfaceDark,
                                child: Center(
                                  child: Text(
                                    champion.initials,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Overlay sutil al estar seleccionado
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    borderColor.withValues(alpha: 0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Nombre del campeón
                  Text(
                    champion.name,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // ⭐ ESTRELLA DE FAVORITO
            Positioned(
              top: 2,
              right: 2,
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite
                    ? AppColors.accentGold
                    : AppColors.textMuted.withValues(),
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}