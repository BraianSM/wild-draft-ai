package com.example.wildrift_draft_ai

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.WindowManager
import android.widget.FrameLayout
import android.graphics.drawable.GradientDrawable
import android.graphics.Color

class OverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private var overlayView: FrameLayout? = null
    private var params: WindowManager.LayoutParams? = null
    private lateinit var gestureDetector: GestureDetector

    private var initialX = 0
    private var initialY = 0
    private var initialTouchX = 0f
    private var initialTouchY = 0f

    companion object {
        const val CHANNEL_ID = "overlay_channel"
        const val NOTIFICATION_ID = 1
        const val ACTION_OVERLAY_EVENT = "com.example.wildrift_draft_ai.OVERLAY_EVENT"
    }

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val channel = NotificationChannel(
            CHANNEL_ID,
            "Overlay Service",
            NotificationManager.IMPORTANCE_LOW
        )
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(channel)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(NOTIFICATION_ID, buildNotification())
        createOverlayWindow()
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        removeOverlayWindow()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun buildNotification(): Notification {
        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Círculo activo")
            .setContentText("Desliza para moverlo")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .build()
    }

    @Suppress("ClickableViewAccessibility")
    private fun createOverlayWindow() {
        val circleSizeDp = 50f
        val px = dpToPx(circleSizeDp).toInt()

        overlayView = FrameLayout(this).apply {
            val drawable = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.parseColor("#00BFFF"))
                setStroke(2, Color.WHITE)
            }
            background = drawable
        }

        params = WindowManager.LayoutParams(
            px,
            px,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                    or WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
                    or WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = (getScreenWidth() / 2 - px / 2)
            y = getScreenHeight() - dpToPx(100f).toInt() - px
        }

        gestureDetector = GestureDetector(this, object : GestureDetector.SimpleOnGestureListener() {
            override fun onSingleTapConfirmed(e: MotionEvent): Boolean {
                sendOverlayEvent("flash")
                return true
            }

            override fun onDoubleTap(e: MotionEvent): Boolean {
                sendOverlayEvent("ignite")
                return true
            }

            override fun onLongPress(e: MotionEvent) {
                sendOverlayEvent("long_press")
            }

            override fun onDown(e: MotionEvent): Boolean {
                initialX = params!!.x
                initialY = params!!.y
                initialTouchX = e.rawX
                initialTouchY = e.rawY
                return true
            }

            override fun onScroll(e1: MotionEvent?, e2: MotionEvent, distanceX: Float, distanceY: Float): Boolean {
                val deltaX = (e2.rawX - initialTouchX).toInt()
                val deltaY = (e2.rawY - initialTouchY).toInt()
                params!!.x = initialX + deltaX
                params!!.y = initialY + deltaY
                windowManager.updateViewLayout(overlayView, params)
                return true
            }
        })

        overlayView!!.setOnTouchListener { _, event ->
            gestureDetector.onTouchEvent(event)
            true
        }

        windowManager.addView(overlayView, params)
    }

    private fun sendOverlayEvent(event: String) {
        val intent = Intent(ACTION_OVERLAY_EVENT)
        intent.setClassName(this, "com.example.wildrift_draft_ai.OverlayEventReceiver")
        intent.putExtra("event", event)
        sendBroadcast(intent)
    }

    private fun removeOverlayWindow() {
        overlayView?.let {
            windowManager.removeView(it)
            overlayView = null
        }
    }

    private fun dpToPx(dp: Float): Float {
        return dp * resources.displayMetrics.density
    }

    private fun getScreenWidth(): Int {
        return resources.displayMetrics.widthPixels
    }

    private fun getScreenHeight(): Int {
        return resources.displayMetrics.heightPixels
    }
}