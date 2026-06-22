import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';
import '../models/flash_tracker_state.dart';
import 'package:flutter/foundation.dart';

class FlashTrackerService {
  static final FlashTrackerService _instance = FlashTrackerService._internal();
  factory FlashTrackerService() => _instance;
  FlashTrackerService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Estado interno
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

    // Android 13+ requiere permiso POST_NOTIFICATIONS
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        debugPrint('🔔 Permiso de notificaciones: $granted');
      }
    }

    // 1. Configurar canal de notificación
    const androidChannel = AndroidNotificationChannel(
      'spell_tracker',
      'Tracker de Hechizos',
      description: 'Controla el enfriamiento de Flash e Ignite',
      importance: Importance.high,
      playSound: false,
      enableVibration: false, // manejamos la vibración aparte
    );

    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // 2. Mostrar notificación inicial
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
    _updateNotification(); // actualizar inmediatamente
  }

  // ──────────────────────── Temporizador ─────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    bool anyPending = false;

    // Verificar Flash
    if (!_flashAvailable && _flashReadyAt != null) {
      if (_flashReadyAt!.isBefore(DateTime.now())) {
        _flashAvailable = true;
        _flashReadyAt = null;
        // Dos vibraciones cortas para Flash
        Vibration.vibrate(pattern: [0, 200, 200, 200]);
        debugPrint('🔔 Flash disponible');
      } else {
        anyPending = true;
      }
    }

    // Verificar Ignite
    if (!_igniteAvailable && _igniteReadyAt != null) {
      if (_igniteReadyAt!.isBefore(DateTime.now())) {
        _igniteAvailable = true;
        _igniteReadyAt = null;
        // Una vibración normal para Ignite
        Vibration.vibrate(duration: 400);
        debugPrint('🔔 Ignite disponible');
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
    // Línea de Flash
    String flashLine;
    if (_flashAvailable) {
      flashLine = 'Flash 🟢';
    } else {
      final min = (SpellState.flashDurationSeconds - _flashReadyAt!.difference(DateTime.now()).inSeconds) ~/ 60;
      final sec = (_flashReadyAt!.difference(DateTime.now()).inSeconds % 60).toString().padLeft(2, '0');
      flashLine = 'Flash 🔴 $min:$sec';
    }

    // Línea de Ignite
    String igniteLine;
    if (_igniteAvailable) {
      igniteLine = 'Ignite 🟢';
    } else {
      final min = (SpellState.igniteDurationSeconds - _igniteReadyAt!.difference(DateTime.now()).inSeconds) ~/ 60;
      final sec = (_igniteReadyAt!.difference(DateTime.now()).inSeconds % 60).toString().padLeft(2, '0');
      igniteLine = 'Ignite 🔴 $min:$sec';
    }

    final content = '$flashLine  $igniteLine';
    debugPrint('📱 Actualizando notificación: $content');

    final androidDetails = AndroidNotificationDetails(
      'spell_tracker',
      'Tracker de Hechizos',
      channelDescription: 'Estado de Flash e Ignite',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      actions: [
        AndroidNotificationAction(
          'spell_FLASH',
          'FLASH',
          showsUserInterface: true,
          cancelNotification: false,
        ),
        AndroidNotificationAction(
          'spell_IGNITE',
          'IGNITE',
          showsUserInterface: true,
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