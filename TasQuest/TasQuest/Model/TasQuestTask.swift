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
    var dueDate: Date // YYYY-MM-DD
    var maxHealth: Float
    var currentHealth: Float
    var tags: [Tag]
    var isVisible: Bool//タスクの可視性を表す。あまりやる予定のないタスクや、終わったタスクを表示するか否かのオプションで使用予定
    var createdAt: Date // YYYY-MM-DD/HH:MM:SS
    var updatedAt: Date // YYYY-MM-DD/HH:MM:SS

    init(id: String, name: String, description: String, dueDate: Date, maxHealth: Float, currentHealth: Float, tags: [Tag], isVisible: Bool, createdAt: Date, updatedAt: Date) {
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
