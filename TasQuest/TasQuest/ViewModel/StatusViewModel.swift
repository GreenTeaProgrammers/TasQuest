//
//  StatusViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/08.
//

import Foundation
import SwiftUI


class StatusViewModel: ObservableObject {
    
    @Published var user: AppData = AppData() // これはUIと同期されます
    
    // 使用例
    let fetchThrottler = Throttler(delay: 10)  // 60秒ごとに実行を許可
    // fetchAppData()が呼び出されたら、非同期でデータを取得して@Publishedプロパティを更新する
    func fetchAppData(completion: @escaping (AppData?) -> Void) {
        fetchThrottler.run {
            FirestoreManager.shared.fetchAppData { fetchedAppData in
                guard let fetchedAppData = fetchedAppData else {
                    print("Failed to fetch AppData")
                    completion(nil)
                    return
                }
                self.user = fetchedAppData
                completion(fetchedAppData)
            }
        }
    }
    
    func backgroundColor(for index: Int) -> Color {
        switch index {
        case 0: return Color(red: (255-30)/255, green: (226-30)/255, blue: (221-30)/255).opacity(1) // 赤寄りのピンク、少し濃い
        case 1: return Color(red: (253-30)/255, green: (236-30)/255, blue: (200-30)/255).opacity(1) // 黄色よりのオレンジ、少し濃い
        case 2: return Color(red: (219-30)/255, green: (237-30)/255, blue: (219-30)/255).opacity(1)
        default: return Color.gray
        }
    }

    func toggleStar(forGoalWithID goalID: String) {
        if let statusIndex = user.statuses.firstIndex(where: { status in
            status.goals.contains { $0.id == goalID }
        }), let goalIndex = user.statuses[statusIndex].goals.firstIndex(where: { $0.id == goalID }) {
            user.statuses[statusIndex].goals[goalIndex].isStarred.toggle()
        }
    }
}
