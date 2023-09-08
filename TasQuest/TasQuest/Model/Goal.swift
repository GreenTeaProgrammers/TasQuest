//
//  Goal.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/05.
//

import Foundation

struct Goal: Codable {
    let id: String
    var name: String
    var description: String
    var tasks: [TasQuestTask]
    var currentTaskIndex: Int
    var dueDate: String //YYYY-MM-DD
    var isStarred: Bool
    var tags: [Tag]
    var thumbnail: String //サムネイルIMGファイルの名前
    //var layoutId: TasQuestLayout
    var createdAt: String //YYYY-MM-DD/HH:MM:SS
    var updatedAt: String //YYYY-MM-DD/HH:MM:SS
}
