//
//  Task.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//

import Foundation

struct TasQuestTask: Codable, Identifiable {
    let id: String
    var name: String
    var description: String
    var dueDate: String // YYYY-MM-DD
    var maxHealth: Float
    var currentHealth: Float
    var tags: [Tag]
    var isVisible: Bool//タスクの可視性を表す。あまりやる予定のないタスクや、終わったタスクを表示するか否かのオプションで使用予定
    var createdAt: String // YYYY-MM-DD/HH:MM:SS
    var updatedAt: String // YYYY-MM-DD/HH:MM:SS

    init(dictionary: [String: Any], tags: [Tag]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.dueDate = dictionary["dueDate"] as? String ?? ""
        self.maxHealth = dictionary["maxHealth"] as? Float ?? 0
        self.currentHealth = dictionary["currentHealth"] as? Float ?? 0
        self.tags = tags
        self.isVisible = dictionary["isVisible"] as? Bool ?? true
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }

    init(id: String, name: String, description: String, dueDate: String, maxHealth: Float, currentHealth: Float, tags: [Tag], isVisible: Bool, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.description = description
        self.dueDate = dueDate
        self.maxHealth = maxHealth
        self.currentHealth = currentHealth
        self.tags = tags
        self.isVisible = isVisible
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}