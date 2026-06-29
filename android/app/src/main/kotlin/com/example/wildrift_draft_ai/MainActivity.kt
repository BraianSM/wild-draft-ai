package com.example.wildrift_draft_ai

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val OVERLAY_CONTROL_CHANNEL = "overlay_control"
        private const val OVERLAY_EVENTS_CHANNEL = "overlay_events"

        private var eventsChannel: MethodChannel? = null

        fun sendEventToFlutter(event: String) {
            eventsChannel?.invokeMethod(event, null)
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Canal para iniciar el overlay
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OVERLAY_CONTROL_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startOverlay" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                            !Settings.canDrawOverlays(this)
                        ) {
                            val intent = Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:$packageName")
                            )
                            startActivity(intent)
                            result.success(false)
                        } else {
                            val serviceIntent = Intent(this, OverlayService::class.java)
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                startForegroundService(serviceIntent)
                            } else {
                                startService(serviceIntent)
                            }
                            result.success(true)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Canal para obtener la versión del SDK de Android (usado por FlashTrackerService)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.wildrift_draft_ai/sdk")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getSdkVersion" -> result.success(Build.VERSION.SDK_INT)
                    else -> result.notImplemented()
                }
            }

        // Canal de eventos del overlay
        eventsChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OVERLAY_EVENTS_CHANNEL)
    }
}