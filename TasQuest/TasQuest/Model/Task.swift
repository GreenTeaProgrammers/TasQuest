//
//  Task.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//

import Foundation

struct Task: Codable {
    let id: Int
    var name: String
    var description: String
    var dueDate: String // YYYY-MM-DD
    var maxHealth: Float
    var currentHealth: Float
    var tags: [Tag]
    var isVisible: Bool//タスクの可視性を表す。あまりやる予定のないタスクや、終わったタスクを表示するか否かのオプションで使用予定
    var createdAt: String // YYYY-MM-DD/HH:MM:SS
    var updatedAt: String // YYYY-MM-DD/HH:MM:SS
}
