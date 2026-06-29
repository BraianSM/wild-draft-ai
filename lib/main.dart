import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Agrega este import
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
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