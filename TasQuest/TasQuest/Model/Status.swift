//
//  Status.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
///Users/its/Documents/Programming/TasQuest/TasQuest/TasQuest/Model/AppData.swift

import Foundation

struct Status: Codable, Identifiable {
    let id: String
    var name: String
    var goals: [Goal]
    var updatedAt: String // YYYY-MM-DD/HH:MM:SS

    init(data: [String: Any], goals: [Goal]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.goals = goals
        self.updatedAt = data["updatedAt"] as? String ?? ""
    }

    init(id: String, name: String, goals: [Goal], updatedAt: String) {
        self.id = id
        self.name = name
        self.goals = goals
        self.updatedAt = updatedAt
    }
}
