//
//  AppData.swift
//  TasQuest
//
//  Created by KAWAGUCHI KINJI on 2023/09/05.
//

import Foundation

struct AppData: Codable {
    let userid: String // これが必要かどうかは要検討
    var username: String //同上
    var statuses: [Status]
    var tags: [Tag]
}
