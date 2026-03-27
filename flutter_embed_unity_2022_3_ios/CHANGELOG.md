## 2.0.0

### Breaking change for iOS!

Due to structural changes required to support Swift Package Manager, you now need to add UnityFramework.framework from your exported Unity-iPhone to your Runner target's list of embedded frameworks in Xcode:

* In Xcode, open `<your project root>/ios/Runner.xcworkspace`
* Select 'Runner' in the project navigator
* Under Targets, select 'Runner'
* In the General tab, scroll down to 'Frameworks, Libraries, and Embedded Content'
* Click on `+` and choose Workspace -> Unity-iPhone -> UnityFramework.framework

You may also need to run `flutter clean` before rebuilding your project.

### New features

* Support for [Swift Package Manager](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers) (you can now use SPM instead of Cocoapods to install flutter_embed_unity)

### Other

* Increased minimum Flutter version to 3.35 due to problems with Unity, Xcode 26 and Flutter JIT. See [#73](https://github.com/learntoflutter/flutter_embed_unity/issues/73)


## 1.0.2

31 July 2024

* Lowered Dart SDK constraint to 2.18+


## 1.0.1

20 November 2023

* Fix [#10](https://github.com/learntoflutter/flutter_embed_unity/issues/10)


## 1.0.0

12 October 2023

* First production release


## 0.0.7-beta

3 October 2023

* Removed green placeholder when Unity is detached from `EmbedUnity`


## 0.0.6-beta

28 September 2023

* Update platform interface dependency


## 0.0.5-beta

27 September 2023

* Fix [issue #6](https://github.com/learntoflutter/flutter_embed_unity/issues/6)
* Fix iOS platform package dependency name in iOS example app


## 0.0.4-beta

* Update dependencies


## 0.0.3-beta

* Minor changes to the README


## 0.0.2-beta

* **Breaking change:** due to a change in namespace, you MUST upgrade the `SendToFlutter.cs` script in your Unity project to use the new version from [the v0.0.2-beta release assets flutter_embed_unity_2022_3.unitypackage](https://github.com/learntoflutter/flutter_embed_unity/releases). Alternatively you can review [the source for SendToFlutter.cs](https://github.com/learntoflutter/flutter_embed_unity/blob/main/example_unity_2022_3_project/Assets/FlutterEmbed/SendToFlutter/SendToFlutter.cs) and make the change to the `AndroidJavaClass` package namespace manually.


## 0.0.1-beta

* Initial beta release