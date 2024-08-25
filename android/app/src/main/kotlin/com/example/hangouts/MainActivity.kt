package com.example.hangouts

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hangouts.com/sms")
        channel.setMethodCallHandler { call : MethodCall, result : MethodChannel.Result ->
            when (call.method) {
                "getLatestSms" -> {
                    val sms = getLatestSms()
                    result.success(sms)
                }

                "sendMessage" -> {
                    val phoneNumber = call.argument<String>("phoneNumber") ?: ""
                    val message = call.argument<String>("message") ?: ""
                    sendSms(phoneNumber, message)
                    result.success(null)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getLatestSms(): String? {
        // Implement your logic to fetch the latest SMS
        return null
    }

    private fun sendSms(phoneNumber: String, message: String) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNumber, null, message, null, null)
            // Handle success (e.g., display a success message)
        } catch (e: Exception) {
            // Handle errors (e.g., display an error message, log the exception)
        }
    }
}