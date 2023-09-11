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
    var createdAt: Date // YYYY-MM-DD/HH:MM:SS
    var updatedAt: Date // YYYY-MM-DD/HH:MM:SS

    init(id: String, name: String, color: [Float], createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.color = color
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
