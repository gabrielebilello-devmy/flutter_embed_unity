library flutter_embed_unity;

import 'package:flutter_embed_unity_platform_interface/flutter_embed_unity_platform_interface.dart';

export 'src/embed_unity.dart' show EmbedUnity;
export 'src/embed_unity_preferences.dart' show EmbedUnityPreferences, MessageFromUnityListeningBehaviour;
export 'package:flutter_embed_unity/flutter_embed_unity.dart' show sendToUnity, pauseUnity, resumeUnity, unloadUnity;

FlutterEmbedUnityPlatform get _platform => FlutterEmbedUnityPlatform.instance;

/// Send [data] to a public MonoBehaviour method named [methodName] attached to a
/// Unity game object named [gameObjectName] in the active scene.
///
/// The Unity method must be public and accept a single [String] parameter.
void sendToUnity(String gameObjectName, String methodName, String data) {
  _platform.sendToUnity(gameObjectName, methodName, data);
}

/// Pause time in Unity.
///
/// Unity will remain loaded in memory and still be able to accept messages.
void pauseUnity() {
  _platform.pauseUnity();
}

/// Resume time in Unity.
void resumeUnity() {
  _platform.resumeUnity();
}

/// Unload Unity from memory to free up resources (RAM, GPU, CPU).
///
/// Unlike [pauseUnity] (which keeps Unity loaded in the background), this releases
/// the Unity engine. Any in-memory Unity state is lost and the next time an
/// [EmbedUnity] widget is shown Unity will perform a (slower) cold start.
///
/// Platform notes:
/// - iOS: performs a real unload via `UnityFramework.unloadApplication()`, which
///   frees memory without terminating the app.
/// - Android: a true unload is not possible because `UnityPlayer.destroy()` would
///   kill the host process, so this falls back to pausing Unity.
///
/// See also the [EmbedUnity.unloadOnDispose] flag to unload automatically when the
/// last widget leaves the widget tree.
void unloadUnity() {
  _platform.unloadUnity();
}
