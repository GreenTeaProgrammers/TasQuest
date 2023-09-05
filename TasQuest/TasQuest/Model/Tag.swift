//
//  Tag.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//

import Foundation

struct Tag: Codable {
    let id: Int
    var name: String
    var color: [Double] // [R, G, B]
    var createdAt: String // YYYY-MM-DD/HH:MM:SS
    var updatedAt: String // YYYY-MM-DD/HH:MM:SS
}
