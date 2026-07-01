package com.learntoflutter.flutter_embed_unity_android.unity

import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import com.learntoflutter.flutter_embed_unity_android.constants.FlutterEmbedConstants.Companion.logTag
import io.flutter.Log


// Sometimes (not always) when the Activity is resumed, Unity appears to be frozen.
// There must be something internal in UnityPlayer which does this?
// So, add a lifecycle observer so we can resume Unity.
class ResumeUnityOnActivityResume : LifecycleEventObserver {
    override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
        //Log.d(logTag, "Detected lifecycle change $event")

        if (event == Lifecycle.Event.ON_RESUME) {
            // Only resume Unity if there is actually an EmbedUnity widget on screen.
            // Otherwise we would restart Unity's render loop in the background with no
            // visible view, wasting CPU/battery and causing lag. When no view is
            // attached, Unity stays paused until the next EmbedUnity widget is shown.
            if (UnityPlayerSingleton.hasAttachedView) {
                Log.d(logTag, "Activity resumed and a Unity view is attached, resuming Unity")
                // For some reason, we need to pause first, and then resume. Not sure why.
                UnityPlayerSingleton.getInstance()?.pause()
                UnityPlayerSingleton.getInstance()?.resume()
            } else {
                Log.d(logTag, "Activity resumed but no Unity view is attached, leaving Unity paused")
            }
        }
    }
}
