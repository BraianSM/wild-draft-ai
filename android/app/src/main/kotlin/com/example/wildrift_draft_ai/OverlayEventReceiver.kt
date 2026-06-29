package com.example.wildrift_draft_ai

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class OverlayEventReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        val event = intent?.getStringExtra("event") ?: return
        // Llamar al método estático de MainActivity para enviar el evento a Flutter
        MainActivity.sendEventToFlutter(event)
    }
}