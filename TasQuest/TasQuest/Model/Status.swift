//
//  Status.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//


import Foundation

struct Status: Codable, Identifiable {
    let id: String
    var name: String
    var goals: [Goal]
    var updatedAt: Date // YYYY-MM-DD/HH:MM:SS

    init(id: String, name: String, goals: [Goal], updatedAt: Date) {
        self.id = id
        self.name = name
        self.goals = goals
        self.updatedAt = updatedAt
    }
}
