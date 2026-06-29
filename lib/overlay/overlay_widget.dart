import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayCircleWidget extends StatefulWidget {
  const OverlayCircleWidget({super.key});

  @override
  State<OverlayCircleWidget> createState() => _OverlayCircleWidgetState();
}

class _OverlayCircleWidgetState extends State<OverlayCircleWidget> {
  // Posición visual del círculo
  Offset _position = const Offset(100, 400);
  // Posición REAL del dedo (independiente del snap)
  Offset _fingerPosition = const Offset(100, 400);

  bool _isDragging = false;
  bool _isNearTrash = false;

  static const double circleSize = 80.0;
  static const double trashSize = 64.0;
  static const double snapDistance = 100.0;

  Size get _screenSize {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    return Size(
      view.physicalSize.width / view.devicePixelRatio,
      view.physicalSize.height / view.devicePixelRatio,
    );
  }

  // Papelera centrada, bien pegada al fondo
  Offset _trashPosition(Size screen) {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final bottomPadding = MediaQueryData.fromView(view).padding.bottom;
    return Offset(
      screen.width / 2 - trashSize / 2,
      screen.height - trashSize - bottomPadding - 40,
    );
  }

  // Distancia entre el dedo real y el centro de la papelera
  bool _checkNearTrash(Offset fingerPos, Size screen) {
    final trashPos = _trashPosition(screen);
    final trashCenter = Offset(
      trashPos.dx + trashSize / 2,
      trashPos.dy + trashSize / 2,
    );
    final fingerCenter = Offset(
      fingerPos.dx + circleSize / 2,
      fingerPos.dy + circleSize / 2,
    );
    return (fingerCenter - trashCenter).distance < snapDistance;
  }

  void _handleTap() => debugPrint('⚡ TAP');
  void _handleDoubleTap() => debugPrint('🔥 DOUBLE TAP');
  void _handleLongPress() => debugPrint('🕒 LONG PRESS');

  @override
  Widget build(BuildContext context) {
    final screen = _screenSize;
    final trashPos = _trashPosition(screen);

    // Posición visual: si está imanado, centrar sobre la papelera
    final displayPosition = _isNearTrash && _isDragging
        ? Offset(
            screen.width / 2 - circleSize / 2,
            trashPos.dy + trashSize / 2 - circleSize / 2,
          )
        : _position;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Fondo transparente no interactivo
          const Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(color: Colors.transparent),
            ),
          ),

          // Papelera — solo al arrastrar
          if (_isDragging)
            Positioned(
              left: trashPos.dx,
              top: trashPos.dy,
              width: trashSize,
              height: trashSize,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isNearTrash
                        ? const Color.fromARGB(230, 244, 67, 54)
                        : const Color.fromARGB(160, 80, 80, 80),
                    boxShadow: _isNearTrash
                        ? [
                            BoxShadow(
                              color: const Color.fromARGB(120, 244, 67, 54),
                              blurRadius: 16,
                              spreadRadius: 4,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: _isNearTrash ? 32 : 26,
                    ),
                  ),
                ),
              ),
            ),

          // Círculo arrastrable
          AnimatedPositioned(
            duration: (_isNearTrash && _isDragging)
                ? const Duration(milliseconds: 120)
                : Duration.zero,
            left: displayPosition.dx,
            top: displayPosition.dy,
            child: GestureDetector(
              onTap: _handleTap,
              onDoubleTap: _handleDoubleTap,
              onLongPress: _handleLongPress,
              onPanStart: (details) {
                setState(() {
                  _isDragging = true;
                  _isNearTrash = false;
                  _fingerPosition = _position;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  // El dedo SIEMPRE se mueve — esto es lo que permite salir del snap
                  final newX = (_fingerPosition.dx + details.delta.dx)
                      .clamp(0.0, screen.width - circleSize);
                  final newY = (_fingerPosition.dy + details.delta.dy)
                      .clamp(0.0, screen.height - circleSize);
                  _fingerPosition = Offset(newX, newY);

                  // Detectar proximidad basada en el dedo real
                  _isNearTrash = _checkNearTrash(_fingerPosition, screen);

                  // Posición visual solo se actualiza cuando NO está imanado
                  if (!_isNearTrash) {
                    _position = _fingerPosition;
                  }
                });
              },
              onPanEnd: (_) {
                if (_isNearTrash) {
                  FlutterOverlayWindow.closeOverlay();
                  return;
                }
                setState(() {
                  _isDragging = false;
                  _isNearTrash = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isNearTrash
                      ? const Color.fromARGB(220, 244, 67, 54)
                      : const Color.fromARGB(179, 0, 255, 255),
                  boxShadow: [
                    BoxShadow(
                      color: _isNearTrash
                          ? const Color.fromARGB(100, 244, 67, 54)
                          : const Color.fromARGB(80, 0, 255, 255),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: _isNearTrash
                      ? const Icon(Icons.delete, color: Colors.white, size: 28)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}