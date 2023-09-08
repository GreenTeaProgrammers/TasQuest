//
//  Status.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//

import Foundation

struct Status: Codable {
    let id: String
    var name: String
    var goals: [Goal]
    var updatedAt: String // YYYY-MM-DD/HH:MM:SS
}
