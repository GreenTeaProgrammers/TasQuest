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
    
    func toggleIsStarred() {
        self.goal.isStarred.toggle()
        // Todo: ここでデータベースへの保存などの追加処理を行うこともできます。
    }
}
