import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'overlay/overlay_widget.dart';
import 'overlay/overlay_service.dart';

void main() {
  runApp(const WildDraftAIApp());
}

class WildDraftAIApp extends StatefulWidget {
  const WildDraftAIApp({super.key});

  @override
  State<WildDraftAIApp> createState() => _WildDraftAIAppState();
}

class _WildDraftAIAppState extends State<WildDraftAIApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      OverlayService().hide(); // cierra el overlay al matar la app
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wild Draft AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

@pragma('vm:entry-point')
void overlayMain() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayCircleWidget(),
    ),
  );
}