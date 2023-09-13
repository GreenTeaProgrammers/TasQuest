//
//  AppData.swift
//  TasQuest
//
//  Created by KAWAGUCHI KINJI on 2023/09/05.
//

import Foundation

struct AppData: Codable {
    let userid: String
    var username: String
    var statuses: [Status]
    var tags: [Tag]
    var createdAt: Date // YYYY-MM-DD/HH:MM:SS

    init(userid: String = "", username: String = "", statuses: [Status] = [], tags: [Tag] = [], createdAt: Date = Date()) {
        self.userid = userid
        self.username = username
        self.statuses = statuses
        self.tags = tags
        self.createdAt = createdAt
    }
}
