package com.example.prepster

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "logger"
        ).setMethodCallHandler { call, result ->
            if (call.method == "log") {
                val tag = "Prepster"
                val level = call.argument<String>("level") ?: "debug"
                val message = call.argument<String>("message") ?: ""
                when (level.lowercase()) {
                    "trace" -> Log.v(tag, message)
                    "debug" -> Log.d(tag, message)
                    "info" -> Log.i(tag, message)
                    "warning" -> Log.w(tag, message)
                    "error", "fatal" -> Log.e(tag, message)
                    else -> Log.d(tag, message)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}

