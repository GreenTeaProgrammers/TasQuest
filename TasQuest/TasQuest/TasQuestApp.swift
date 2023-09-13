//
//  TasQuestApp.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//

import SwiftUI
import Firebase
import UIKit

@main
struct TasQuestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                StatusView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    lazy var window: UIWindow? = .init(frame: UIScreen.main.bounds)
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        // Initialize Firebase
        FirebaseApp.configure()
      
        // Initialize Unity
        Unity.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
      
        // Initialize UIWindow and set ViewController
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
      
        return true
    }
}

class LaunchViewController: UIViewController {}

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
