//
//  AppData.swift
//  TasQuest
//
//  Created by KAWAGUCHI KINJI on 2023/09/05.
//

import Foundation

class AppDataSingleton: Codable {
    static let shared = AppDataSingleton()

    var appData: AppData

    private init() {
        self.appData = AppData() // 初期化
    }

    func updateAppData(with json: String) {
        do {
            if let data = json.data(using: .utf8) {
                let updatedAppData = try JSONDecoder().decode(AppData.self, from: data)
                self.appData = updatedAppData
            }
        } catch {
            print("Failed to update AppData:", error)
        }
    }
}

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
