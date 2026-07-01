import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_flutter_embed_unity.dart';

/// The interface that implementations of flutter_embed_unity must implement.
///
/// Platform implementations should extend this class rather than implement it as `flutter_embed_unity`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [FlutterEmbedUnityPlatform] methods.
abstract class FlutterEmbedUnityPlatform extends PlatformInterface {
  /// Constructs a FlutterEmbedUnityPlatform.
  FlutterEmbedUnityPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEmbedUnityPlatform _instance = MethodChannelFlutterEmbedUnity();

  /// The default instance of [FlutterEmbedUnityPlatform] to use,
  /// defaults to [FlutterEmbedUnityPlatformUnsupported].
  static FlutterEmbedUnityPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterEmbedUnityPlatform] when they register themselves.
  static set instance(FlutterEmbedUnityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Send [data] to a public MonoBehaviour method named [methodName] attached to a
  /// Unity game object named [gameObjectName] in the active scene.
  ///
  /// The Unity method must be public and accept a single [String] parameter.
  void sendToUnity(String gameObjectName, String methodName, String data) {
    throw UnimplementedError('sendToUnity() has not been implemented.');
  }

  /// Pause time in Unity.
  ///
  /// Unity will remain loaded in memory and still be able to accept messages.
  void pauseUnity() {
    throw UnimplementedError('pauseUnity() has not been implemented.');
  }

  /// Resume time in Unity.
  void resumeUnity() {
    throw UnimplementedError('resumeUnity() has not been implemented.');
  }

  /// Unload Unity from memory to free up resources (RAM, GPU, CPU).
  ///
  /// Unlike [pauseUnity] (which keeps Unity loaded in the background), this releases
  /// the Unity engine. Any in-memory Unity state is lost and the next time an
  /// [EmbedUnity] widget is shown Unity will perform a cold start.
  ///
  /// Platform notes:
  /// - iOS: performs a real unload via `UnityFramework.unloadApplication()`, which
  ///   frees memory without terminating the app.
  /// - Android: a true unload is not possible because `UnityPlayer.destroy()` would
  ///   kill the host process, so this falls back to pausing Unity.
  void unloadUnity() {
    throw UnimplementedError('unloadUnity() has not been implemented.');
  }
}
