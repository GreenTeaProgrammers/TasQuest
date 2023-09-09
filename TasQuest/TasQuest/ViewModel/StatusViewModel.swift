//
//  StatusViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/08.
//

import Foundation
import SwiftUI


class StatusViewModel: ObservableObject {

    @Published var user: AppData = AppData()
    
    func setDummyData() -> AppData{
        return AppData(userid: "1", username: "Kinji", statuses: [
            Status(id: "1", name: "未着手", goals: [
                Goal(id: "1", name: "Goal 1", description: "", tasks: [], dueDate: "2023-09-20", isStarred: false, tags: [], thumbnail: "", createdAt: "", updatedAt: ""),
                Goal(id: "2", name: "Goal 2", description: "", tasks: [], dueDate: "2023-10-01", isStarred: true, tags: [], thumbnail: "", createdAt: "", updatedAt: "")
            ], updatedAt: ""),
            Status(id: "2", name: "対応中", goals: [
                Goal(id: "3", name: "Goal 3", description: "", tasks: [], dueDate: "2023-09-22", isStarred: false, tags: [], thumbnail: "", createdAt: "", updatedAt: "")
            ], updatedAt: ""),
            Status(id: "3", name: "完了", goals: [
                Goal(id: "4", name: "Goal 4", description: "", tasks: [], dueDate: "2023-09-19", isStarred: true, tags: [], thumbnail: "", createdAt: "", updatedAt: "")
            ], updatedAt: "")
        ], tags: [])
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
