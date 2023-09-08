//
//  StatusViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/08.
//

import Foundation


class StatusViewModel: ObservableObject {
    @Published var goal: Goal
    
    init(goal: Goal) {
        self.goal = goal
    }
    
    func toggleIsStarred() -> Goal{
        self.goal.isStarred.toggle()
        return self.goal
        // Todo: ここでデータベースへの保存などの追加処理を行うこともできます。
    }
}
