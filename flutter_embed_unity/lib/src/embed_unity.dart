import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_embed_unity/src/unity_message_listener.dart';
import 'package:flutter_embed_unity/src/unity_message_listeners.dart';
import 'package:flutter_embed_unity_platform_interface/flutter_embed_constants.dart';

/// Embed Unity into your Flutter app and listen for messages from your Unity scripts.
///
/// Unity will be rendered within the bounds of the widget.
/// Only 1 instance of the widget should be shown on a screen.
class EmbedUnity extends StatefulWidget {
  /// Listen to messages sent from Unity via `SendToFlutter.cs`.
  final Function(String)? onMessageFromUnity;

  /// When `true`, Unity is unloaded from memory when the last [EmbedUnity]
  /// widget is removed from the widget tree, freeing up resources (RAM, GPU, CPU).
  ///
  /// When `false` (the default), Unity is only paused and kept alive in the
  /// background, so it can resume instantly and preserve its state.
  ///
  /// Platform notes:
  /// - iOS: performs a real unload, freeing memory. The next time an [EmbedUnity]
  ///   widget is shown, Unity performs a (slower) cold start and its state is lost.
  /// - Android: a true unload is not possible (it would kill the host process),
  ///   so this only ensures Unity is paused.
  final bool unloadOnDispose;

  const EmbedUnity({
    this.onMessageFromUnity,
    this.unloadOnDispose = false,
    super.key,
  });

  @override
  State<EmbedUnity> createState() => _EmbedUnityState();
}

class _EmbedUnityState extends State<EmbedUnity> implements UnityMessageListener {
  @override
  void initState() {
    UnityMessageListeners.instance.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    UnityMessageListeners.instance.removeListener(this);
    super.dispose();
  }

  @override
  void onMessageFromUnity(String data) {
    widget.onMessageFromUnity?.call(data);
  }

  @override
  Widget build(BuildContext context) {
    final creationParams = <String, dynamic>{
      FlutterEmbedConstants.creationParamUnloadOnDispose: widget.unloadOnDispose,
    };
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: FlutterEmbedConstants.uniqueIdentifier,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (int id) {
            debugPrint('FlutterEmbed: onPlatformViewCreated($id)');
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: FlutterEmbedConstants.uniqueIdentifier,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (int id) {
            debugPrint('FlutterEmbed: onPlatformViewCreated($id)');
          },
        );
      default:
        throw UnsupportedError('Unsupported platform: $defaultTargetPlatform');
    }
  }
}
