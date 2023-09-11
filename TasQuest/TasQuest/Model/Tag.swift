//
//  Tag.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//

import Foundation

struct Tag: Codable, Identifiable, Hashable, Equatable {
    let id: String
    var name: String
    var color: [Float] // [R, G, B]
    var createdAt: String // YYYY-MM-DD/HH:MM:SS
    var updatedAt: String // YYYY-MM-DD/HH:MM:SS

    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.color = dictionary["color"] as? [Float] ?? []
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }

    init(id: String, name: String, color: [Float], createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.color = color
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
