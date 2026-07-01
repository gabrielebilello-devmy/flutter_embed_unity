import Foundation
import UnityFramework

class UnityPlayerSingleton {
    private static let dataBundleId: String = "com.unity3d.framework"
    private static let frameworkPath: String = "/Frameworks/UnityFramework.framework"

    // We must use a singleton Unity instance, because it was never designed to be
    // reused in multiple views. The workaround is to only
    // create Unity once, and keep it alive when the view is disposed
    // so it can be reattach onto the next view.
    static private var unityFramework : UnityFramework?

    // Listens for Unity unload / quit events so we can clear our reference to the
    // framework, allowing it to be recreated (a cold start) the next time it's needed.
    static private let frameworkListener = UnityFrameworkListenerImpl()

    static var isInitialised: Bool {
        get {
            return self.unityFramework != nil
        }
    }

    static func getInstance() -> UnityFramework {
        if let unityFramework = self.unityFramework {
            return unityFramework
        }
        else {
            // Load the Unity engine
            let bundlePath = Bundle.main.bundlePath.appending(frameworkPath)
            let unityBundle = Bundle.init(path: bundlePath)!
            let unityFramework = unityBundle.principalClass!.getInstance()!
            unityFramework.setDataBundleId(dataBundleId)

            // Register a listener so we're notified when Unity finishes unloading,
            // so we can clear our static reference (see unload() / onUnityUnloaded())
            unityFramework.register(frameworkListener)

            unityFramework.runEmbedded(
                withArgc: CommandLine.argc,
                argv: CommandLine.unsafeArgv,
                appLaunchOpts: nil
            )

            // Got this hack from
            // https://github.com/juicycleff/flutter-unity-view-widget/blob/master/ios/Classes/UnityPlayerUtils.swift
            // Without this, touches do not register in Flutter. Not sure why - I think the Unity
            // view is set to a level above Flutter and captures all touches?
            // There are 3 defined levels:
            // UIWindow.Level.normal (rawValue: 0.0)
            // UIWindow.Level.statusBar (rawValue: 1000.0)
            // UIWindow.Level.alert (rawValue: 2000.0)
            // appController window level is UIWindow.Level.normal (rawValue: 0.0),
            // so setting to -1 should put it to a level underneath normal?
            unityFramework.appController()?.window?.windowLevel = UIWindow.Level(-1)

            self.unityFramework = unityFramework
            return unityFramework
        }
    }

    // Unload Unity from memory, freeing up resources (RAM, GPU, CPU), without
    // terminating the app. Unlike Android, iOS supports unloading and reloading
    // Unity (Unity as a Library): the next call to getInstance() will recreate it.
    // Note: this loses any in-memory Unity state, and reloading is a cold start.
    // unloadApplication() is asynchronous; our static reference is cleared when the
    // frameworkListener receives unityDidUnload (see onUnityUnloaded()).
    static func unload() {
        guard let unityFramework = self.unityFramework else {
            debugPrint("Didn't unload Unity: Unity is not loaded")
            return
        }
        NSLog("UnityPlayerSingleton: unloading Unity from memory")
        unityFramework.unloadApplication()
    }

    // Called by the framework listener once Unity has finished unloading / quitting.
    fileprivate static func onUnityUnloaded() {
        NSLog("UnityPlayerSingleton: Unity did unload, clearing reference so it can be recreated")
        self.unityFramework?.unregister(frameworkListener)
        self.unityFramework = nil
    }
}

// A small NSObject conforming to UnityFrameworkListener. UnityPlayerSingleton uses
// static state, but registerFrameworkListener requires an NSObject instance, so we
// forward the callbacks back to the singleton.
private class UnityFrameworkListenerImpl: NSObject, UnityFrameworkListener {
    func unityDidUnload(_ notification: Notification!) {
        UnityPlayerSingleton.onUnityUnloaded()
    }

    func unityDidQuit(_ notification: Notification!) {
        UnityPlayerSingleton.onUnityUnloaded()
    }
}
