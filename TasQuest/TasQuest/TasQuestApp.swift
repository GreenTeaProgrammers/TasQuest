//
//  TasQuestApp.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//

import SwiftUI
import Firebase
import UIKit

class LaunchViewController: UIViewController {}

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            StatusView()
        }
    }
}

// UnityHostingController: UIViewControllerRepresentableを使ってUnityのUIViewをSwiftUIに埋め込む
struct UnityHostingController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 更新が必要な場合はここにコードを書く
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Unityの初期化のみ行い、ビューはまだ表示しない
        Unity.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        return true
    }
}

// 以前のViewController（変更なし、Unityのビューを管理）
class ViewController: UIViewController {
    private let unityView = Unity.shared.view
    
    override func loadView() {
        super.loadView()
        view.addSubview(unityView)
        NSLayoutConstraint.activate([
            unityView.topAnchor.constraint(equalTo: view.topAnchor),
            unityView.leftAnchor.constraint(equalTo: view.leftAnchor),
            unityView.rightAnchor.constraint(equalTo: view.rightAnchor),
            unityView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
