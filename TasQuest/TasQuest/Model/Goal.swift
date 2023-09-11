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
    var dueDate: String //YYYY-MM-DD
    var isStarred: Bool
    var tags: [Tag]
    var thumbnail: String? //サムネイルIMGファイルの名前
    //var layoutId: TasQuestLayout
    var createdAt: String //YYYY-MM-DD/HH:MM:SS
    var updatedAt: String //YYYY-MM-DD/HH:MM:SS
    
    init(data: [String: Any], tasks: [TasQuestTask], tags: [Tag]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.tasks = tasks
        self.dueDate = data["dueDate"] as? String ?? ""
        self.isStarred = data["isStarred"] as? Bool ?? false
        self.tags = tags
        self.thumbnail = data["thumbnail"] as? String ?? ""
        self.createdAt = data["createdAt"] as? String ?? ""
        self.updatedAt = data["updatedAt"] as? String ?? ""
    }

    init(id: String, name: String, description: String, tasks: [TasQuestTask], dueDate: String, isStarred: Bool, tags: [Tag], thumbnail: String, createdAt: String, updatedAt: String) {
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
