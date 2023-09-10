//
//  TasQuestApp.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//

import SwiftUI
import Firebase

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
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
