//
//  AppData.swift
//  TasQuest
//
//  Created by KAWAGUCHI KINJI on 2023/09/05.
//

struct AppData: Codable {
    let userid: String
    var username: String
    var statuses: [Status]
    var tags: [Tag]
    var createdAt: String // YYYY-MM-DD/HH:MM:SS

    init(userid: String = "", username: String = "", statuses: [Status] = [], tags: [Tag] = [], createdAt: String = "") {
        self.userid = userid
        self.username = username
        self.statuses = statuses
        self.tags = tags
        self.createdAt = createdAt
    }
}
