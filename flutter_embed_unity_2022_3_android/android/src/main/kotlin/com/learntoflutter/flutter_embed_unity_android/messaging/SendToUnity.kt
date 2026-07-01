package com.learntoflutter.flutter_embed_unity_android.messaging

import com.learntoflutter.flutter_embed_unity_android.constants.FlutterEmbedConstants.Companion.logTag
import com.learntoflutter.flutter_embed_unity_android.constants.FlutterEmbedConstants.Companion.methodNamePauseUnity
import com.learntoflutter.flutter_embed_unity_android.constants.FlutterEmbedConstants.Companion.methodNameResumeUnity
import com.learntoflutter.flutter_embed_unity_android.constants.FlutterEmbedConstants.Companion.methodNameSendToUnity
import com.learntoflutter.flutter_embed_unity_android.constants.FlutterEmbedConstants.Companion.methodNameUnloadUnity
import com.learntoflutter.flutter_embed_unity_android.unity.UnityPlayerSingleton
import com.unity3d.player.UnityPlayer
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SendToUnity: MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            methodNameSendToUnity -> {
                val gameObjectMethodNameData = (call.arguments as List<*>).filterIsInstance<String>()
                UnityPlayer.UnitySendMessage(
                    gameObjectMethodNameData[0], // Unity game object name
                    gameObjectMethodNameData[1], // Game object method name
                    gameObjectMethodNameData[2]) // Data
            }
            methodNamePauseUnity -> {
                UnityPlayerSingleton.getInstance()?.pause()
            }
            methodNameResumeUnity -> {
                UnityPlayerSingleton.getInstance()?.resume()
            }
            methodNameUnloadUnity -> {
                // On Android a true unload is not possible: UnityPlayer.destroy() would
                // kill the whole app process (it was designed to own its own activity /
                // process). So the best we can do is pause Unity to reduce resource usage.
                Log.i(logTag, "unloadUnity requested. On Android Unity cannot be unloaded " +
                        "without killing the app process, so pausing Unity instead.")
                UnityPlayerSingleton.getInstance()?.pause()
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}