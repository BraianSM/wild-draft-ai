import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  static final OverlayService _instance = OverlayService._internal();
  factory OverlayService() => _instance;
  OverlayService._internal();

  bool _isShown = false;

  Future<bool> checkPermission() async {
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  Future<bool> requestPermission() async {
    return await FlutterOverlayWindow.requestPermission() ?? false;
  }

  Future<void> show() async {
    if (_isShown) return;

    final hasPermission = await checkPermission();
    if (!hasPermission) {
      debugPrint('🔴 Permiso no concedido');
      return;
    }

    await FlutterOverlayWindow.showOverlay(
      height: WindowSize.matchParent,
      width: WindowSize.matchParent,
      flag: OverlayFlag.focusPointer,
      overlayTitle: 'Tracker Circle',
    );

    _isShown = true;
    debugPrint('🔵 Overlay mostrado');
  }

  Future<void> hide() async {
    if (!_isShown) return;
    await FlutterOverlayWindow.closeOverlay();
    _isShown = false;
    debugPrint('🔴 Overlay cerrado');
  }
}