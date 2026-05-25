// WIDGET: Tarjeta que muestra cada campeón en el grid
// Diseño: imagen grande + nombre pequeño + roles
// Sin botones, sin espacios vacíos

import 'package:flutter/material.dart';
import '../models/champion.dart';

class ChampionCard extends StatelessWidget {
  final Champion champion;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? borderColor;

  const ChampionCard({
    super.key,
    required this.champion,
    required this.isSelected,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : onTap,
      child: Card(
        color: isSelected ? Colors.grey[850] : const Color(0xFF161B22),
        elevation: isSelected ? 0 : 1,
        margin: EdgeInsets.zero, // Sin margen extra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: isSelected 
                ? Colors.green 
                : borderColor ?? Colors.transparent,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGEN GRANDE - ocupa la mayor parte
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: Image.network(
                  champion.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[800],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.amber,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              champion.initials,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // NOMBRE + ROLES - pequeño abajo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              color: isSelected ? Colors.grey[850] : const Color(0xFF1A1F2E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nombre del campeón
                  Text(
                    champion.name,
                    style: const TextStyle(
                      fontSize: 8, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  
                  // Roles en una línea
                  Text(
                    champion.roles.join(', '),
                    style: TextStyle(
                      fontSize: 6,
                      color: Colors.grey[500],
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  
                  // Check si está seleccionado
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green[400],
                        size: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}