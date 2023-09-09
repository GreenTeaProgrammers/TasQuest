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
    
    init(userid: String = "", username: String = "", statuses: [Status] = [], tags: [Tag] = []) {
        self.userid = userid
        self.username = username
        self.statuses = statuses
        self.tags = tags
    }
}
