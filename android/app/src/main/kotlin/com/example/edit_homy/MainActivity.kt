package com.example.edit_homy

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sms_sender"
    private val SMS_PERMISSION_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        createNotificationChannel()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "sendSms") {
                    val phone = call.argument<String>("phone")
                    val message = call.argument<String>("message")

                    if (phone.isNullOrBlank() || message.isNullOrBlank()) {
                        result.error("INVALID_DATA", "phone or message is null", null)
                        return@setMethodCallHandler
                    }

                    if (ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.SEND_SMS
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(Manifest.permission.SEND_SMS),
                            SMS_PERMISSION_CODE
                        )
                        result.error("NO_PERMISSION", "SEND_SMS permission not granted yet", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val smsManager = getSystemService(SmsManager::class.java)
                        smsManager.sendTextMessage(phone, null, message, null, null)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SMS_FAILED", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "high_importance_channel"
            val channelName = "High Importance Notifications"
            val channelDescription = "This channel is used for important notifications."

            val channel = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = channelDescription
                enableVibration(true)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
}