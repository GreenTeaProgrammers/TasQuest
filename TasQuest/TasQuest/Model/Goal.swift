//
//  Goal.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//

import Foundation

struct Goal: Codable, Identifiable {
    let id: String
    var name: String
    var description: String
    var tasks: [TasQuestTask]
    var dueDate: Date //YYYY-MM-DD
    var isStarred: Bool
    var tags: [Tag]
    var thumbnail: String? //サムネイルIMGファイルの名前
    //var layoutId: TasQuestLayout
    var createdAt: Date //YYYY-MM-DD/HH:MM:SS
    var updatedAt: Date //YYYY-MM-DD/HH:MM:SS
    
    init(id: String, name: String, description: String, tasks: [TasQuestTask], dueDate: Date, isStarred: Bool, tags: [Tag], thumbnail: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.tasks = tasks
        self.dueDate = dueDate
        self.isStarred = isStarred
        self.tags = tags
        self.thumbnail = thumbnail
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
