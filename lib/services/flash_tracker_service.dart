import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';
import '../models/flash_tracker_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Manejador global para acciones en segundo plano
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('🔔 BACKGROUND NOTIFICATION TAP: ${notificationResponse.actionId}');
  FlashTrackerService()._onNotificationResponse(notificationResponse);
}

class FlashTrackerService {
  static final FlashTrackerService _instance = FlashTrackerService._internal();
  factory FlashTrackerService() => _instance;
  FlashTrackerService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  bool _flashAvailable = true;
  DateTime? _flashReadyAt;
  bool _igniteAvailable = true;
  DateTime? _igniteReadyAt;

  Timer? _timer;
  bool _initialized = false;

  // ──────────────────────── Inicialización ────────────────────────
  Future<void> initialize() async {
    if (_initialized) return;

    debugPrint('⚙️ Inicializando Tracker de Hechizos');

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final areEnabled = await androidPlugin.areNotificationsEnabled();
        if (areEnabled == true) {
          debugPrint('🔔 Notificaciones deshabilitadas. Solicitando permiso...');

          // Forzar vertical para mostrar correctamente el diálogo nativo
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);

          final granted = await androidPlugin.requestNotificationsPermission();
          debugPrint('🔔 Permiso concedido: $granted');

          // Restaurar orientaciones (incluyendo horizontal si la app lo permite)
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          debugPrint('🔔 Notificaciones ya habilitadas');
        }
      }
    }

    const androidChannel = AndroidNotificationChannel(
      'spell_tracker',
      'Tracker de Hechizos',
      description: 'Controla el enfriamiento de Flash e Ignite',
      importance: Importance.max,
      playSound: false,
      enableVibration: false,
    );

    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    debugPrint('📱 Mostrando notificación inicial...');
    await _updateNotification();

    debugPrint('✅ Tracker de Hechizos iniciado correctamente');
    _initialized = true;
  }

  // ──────────────────── Marcar Hechizo usado ────────────────────
  void markSpellUsed(String spell) {
    spell = spell.toUpperCase();
    if (spell == 'FLASH') {
      _flashAvailable = false;
      _flashReadyAt = DateTime.now().add(Duration(seconds: SpellState.flashDurationSeconds));
      debugPrint('🔥 Flash usado. Ready at: $_flashReadyAt');
    } else if (spell == 'IGNITE') {
      _igniteAvailable = false;
      _igniteReadyAt = DateTime.now().add(Duration(seconds: SpellState.igniteDurationSeconds));
      debugPrint('🔥 Ignite usado. Ready at: $_igniteReadyAt');
    } else {
      return;
    }

    _startTimer();
    _updateNotification();
  }

  // ──────────────────────── Temporizador ─────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    bool anyPending = false;

    if (!_flashAvailable && _flashReadyAt != null) {
      if (_flashReadyAt!.isBefore(DateTime.now())) {
        _flashAvailable = true;
        _flashReadyAt = null;
        Vibration.vibrate(pattern: [0, 200, 200, 200]);
        debugPrint('🔔 Flash disponible (150s)');
      } else {
        anyPending = true;
      }
    }

    if (!_igniteAvailable && _igniteReadyAt != null) {
      if (_igniteReadyAt!.isBefore(DateTime.now())) {
        _igniteAvailable = true;
        _igniteReadyAt = null;
        Vibration.vibrate(duration: 400);
        debugPrint('🔔 Ignite disponible (100s)');
      } else {
        anyPending = true;
      }
    }

    _updateNotification();

    if (!anyPending) {
      _timer?.cancel();
      _timer = null;
    }
  }

  // ────────────────── Notificación persistente ──────────────────
  Future<void> _updateNotification() async {
    String flashLine;
    if (_flashAvailable) {
      flashLine = 'Flash 🟢';
    } else {
      final remainingSeconds = _flashReadyAt!.difference(DateTime.now()).inSeconds;
      final clampedSeconds = remainingSeconds.clamp(0, SpellState.flashDurationSeconds);
      final min = clampedSeconds ~/ 60;
      final sec = (clampedSeconds % 60).toString().padLeft(2, '0');
      flashLine = 'Flash 🔴 $min:$sec';
    }

    String igniteLine;
    if (_igniteAvailable) {
      igniteLine = 'Ignite 🟢';
    } else {
      final remainingSeconds = _igniteReadyAt!.difference(DateTime.now()).inSeconds;
      final clampedSeconds = remainingSeconds.clamp(0, SpellState.igniteDurationSeconds);
      final min = clampedSeconds ~/ 60;
      final sec = (clampedSeconds % 60).toString().padLeft(2, '0');
      igniteLine = 'Ignite 🔴 $min:$sec';
    }

    final content = '$flashLine  $igniteLine';
    debugPrint('📱 Actualizando notificación: $content');

    final androidDetails = AndroidNotificationDetails(
      'spell_tracker',
      'Tracker de Hechizos',
      channelDescription: 'Estado de Flash e Ignite',
      importance: Importance.max,
      priority: Priority.max,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      actions: [
        AndroidNotificationAction(
          'spell_FLASH',
          'FLASH',
          showsUserInterface: false,
          cancelNotification: false,
        ),
        AndroidNotificationAction(
          'spell_IGNITE',
          'IGNITE',
          showsUserInterface: false,
          cancelNotification: false,
        ),
      ],
    );

    await _notifications.show(
      0,
      '🎮 Tracker de Hechizos',
      content,
      NotificationDetails(android: androidDetails),
    );
  }

  // ───────────── Respuesta a acciones de notificación ────────────
  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('🔔 NOTIFICATION RESPONSE RECEIVED');
    debugPrint('   actionId: ${response.actionId}');

    final actionId = response.actionId;
    if (actionId == 'spell_FLASH') {
      debugPrint('🔔 ACTION RECEIVED: FLASH');
      markSpellUsed('FLASH');
    } else if (actionId == 'spell_IGNITE') {
      debugPrint('🔔 ACTION RECEIVED: IGNITE');
      markSpellUsed('IGNITE');
    }
  }

  // ────────────────────────── Liberar ────────────────────────────
  void dispose() {
    _timer?.cancel();
    _notifications.cancel(0);
  }
}