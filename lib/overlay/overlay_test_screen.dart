import 'package:flutter/material.dart';
import 'overlay_service.dart';

class OverlayTestScreen extends StatelessWidget {
  const OverlayTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overlay = OverlayService();
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: const Text('Test Overlay')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (!await overlay.checkPermission()) {
                  await overlay.requestPermission();
                }
                await overlay.show();
              },
              child: const Text('Mostrar Overlay'),
            ),
            ElevatedButton(
              onPressed: overlay.hide,
              child: const Text('Cerrar Overlay'),
            ),
          ],
        ),
      ),
    );
  }
}