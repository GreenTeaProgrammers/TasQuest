//
//  StatusViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/08.
//

import Foundation
import SwiftUI

/// タスクやゴールの状態を管理するViewModel
class StatusViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// Throttlerインスタンス。fetchAppData関数を10秒ごとに制限する。
    let fetchThrottler = Throttler(delay: 10)  // 10秒ごとに実行を許可
    
    // MARK: - Methods
    
    /// アプリデータを非同期で取得し、@Publishedプロパティを更新する。
    /// - Parameter completion: データ取得後のコールバック。取得に失敗した場合はnil。
    func fetchAppData(completion: @escaping (AppData?) -> Void) {
        fetchThrottler.run {
            FirestoreManager.shared.fetchAppData { fetchedAppData in
                guard let fetchedAppData = fetchedAppData else {
                    print("Failed to fetch AppData")
                    completion(nil)
                    return
                }
                AppDataSingleton.shared.appData = fetchedAppData
                completion(fetchedAppData)
            }
        }
    }
    
    /// インデックスに対応する背景色を返す。
    /// - Parameter index: 背景色を決定するためのインデックス。
    /// - Returns: 計算されたColorオブジェクト。
    func backgroundColor(for index: Int) -> Color {
        switch index {
        case 0: return Color(red: (255-30)/255, green: (226-30)/255, blue: (221-30)/255).opacity(1) // 赤寄りのピンク、少し濃い
        case 1: return Color(red: (253-30)/255, green: (236-30)/255, blue: (200-30)/255).opacity(1) // 黄色よりのオレンジ、少し濃い
        case 2: return Color(red: (219-30)/255, green: (237-30)/255, blue: (219-30)/255).opacity(1) // 青色よりの緑、少し濃い
        default: return Color.gray
        }
    }

    /// 指定されたIDを持つゴールの星マークを切り替える。
    /// - Parameter goalID: 星マークを切り替えるゴールのID。
    func toggleStar(forGoalWithID goalID: String) {
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
                        NotificationCenter.default.post(name: Notification.Name("StatusUpdated"), object: nil)//強制的に全体を再レンダリング
                    } else {
                        // Handle error
                    }
                }
            }
        }
        }
    }
}
