// ARCHIVO PRINCIPAL: Punto de entrada de la app
// Ahora solo configura la app y muestra la pantalla principal

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wild Draft AI',
      // Tema oscuro gaming para toda la app
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.cyan,
        ),
      ),
      // Mostramos la pantalla principal del draft
      home: const HomeScreen(),
    );
  }
}