//
//  SettingView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import SwiftUI

struct SettingView: View {
    @Binding var showSignInView: Bool
    
    @StateObject private var viewModel = SettingViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        AppDataSingleton.shared.appData = AppData() //Todo: Debug it
                        NotificationCenter.default.post(name: Notification.Name("StatusUpdated"), object: nil)//強制的に全体を再レンダリング
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showSignInView = true
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}
