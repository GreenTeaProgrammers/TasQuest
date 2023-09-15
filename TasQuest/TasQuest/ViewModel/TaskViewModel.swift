//
//  TaskViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import Foundation


class TaskViewModel: ObservableObject {
    @Published var goal: Goal
    
    init(goal: Goal) {
        self.goal = goal
    }

    func toggleIsStarred(goalID: String) {
        if let statusIndex = AppDataSingleton.shared.appData.statuses.firstIndex(where: { status in
            status.goals.contains { $0.id == goalID }
            }), let goalIndex = AppDataSingleton.shared.appData.statuses[statusIndex].goals.firstIndex(where: { $0.id == goalID }) {
                AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].isStarred.toggle()
                        FirestoreManager.shared.saveAppData() { error in
                if let error = error {
                    print("Failed to save data: \(error)")
                } else {
                    print("Data saved successfully.")
                    // Updateをフェッチしシングルトンオブジェクトを更新
                    FirestoreManager.shared.fetchAppData { fetchedAppData in
                        if let fetchedAppData = fetchedAppData {
                            AppDataSingleton.shared.appData = fetchedAppData
                            NotificationCenter.default.post(name: Notification.Name("TaskUpdated"), object: nil)//強制的に全体を再レンダリング
                            
                        } else {
                            // Handle error
                        }
                    }
                }
            }
        }
    }
}
