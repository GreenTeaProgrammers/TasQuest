//
//  Unity.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/13.
//


import Foundation
import SwiftUI
import UnityFramework

class Unity: NSObject, UnityFrameworkListener {
    static let shared = Unity()
    private let unityFramework: UnityFramework

    override init() {
        let bundlePath = Bundle.main.bundlePath
        let frameworkPath = bundlePath + "/Frameworks/UnityFramework.framework"
        let bundle = Bundle(path: frameworkPath)!
        if !bundle.isLoaded {
            bundle.load()
        }
        // It needs disable swiftlint rule due to needs for unwrapping before calling super.init()
        // swiftlint:disable:next force_cast
        let frameworkClass = bundle.principalClass as! UnityFramework.Type
        let framework = frameworkClass.getInstance()!
        if framework.appController() == nil {
            var header = _mh_execute_header
            framework.setExecuteHeader(&header)
        }
        unityFramework = framework
        super.init()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        unityFramework.register(self)
        unityFramework.setDataBundleId("com.unity3d.framework")
        unityFramework.runEmbedded(withArgc: CommandLine.argc,
                                   argv: CommandLine.unsafeArgv, appLaunchOpts: launchOptions)
    }

    // UnityのWindowからViewだけを返す
    var view: UIView {
        unityFramework.appController()!.rootView!
    }

    // ネイティブ側からUnityのメソッドを呼び出す
    func sendMessageToUnity(objectName: String, functionName: String, argument: String) {
        unityFramework.sendMessageToGO(withName: objectName, functionName: functionName, message: argument)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        unityFramework.appController()?.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        unityFramework.appController()?.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        unityFramework.appController()?.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        unityFramework.appController()?.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        unityFramework.appController()?.applicationWillTerminate(application)
    }
}
