//
//  StatusViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/08.
//

import Foundation
import SwiftUI


class StatusViewModel: ObservableObject {
    
    @Published var user: AppData = AppData() // これはUIと同期されます
    
    // 使用例
    let fetchThrottler = Throttler(delay: 10)  // 60秒ごとに実行を許可
    // fetchAppData()が呼び出されたら、非同期でデータを取得して@Publishedプロパティを更新する
    func fetchAppData() {
        fetchThrottler.run {
            FirestoreManager.shared.fetchAppData { fetchedAppData in
                guard let fetchedAppData = fetchedAppData else {
                    print("Failed to fetch AppData")
                    return
                }
                
                // 成功した場合、userプロパティに取得したAppDataを格納する
                self.user = fetchedAppData
                
                // デバッグ用
                print("Fetched AppData: \(fetchedAppData)")
                print("Username: \(fetchedAppData.username)")
            }
            
        }
    }
    /*
    let allTags = []/*[Tag(id: "1", name: "urg123123123123ent", color: [1.0, 0.0, 0.0], createdAt: "2023-07-15/12:00:00", updatedAt: "2023-07-15/12:05:00"),
                   Tag(id: "2", name: "database", color: [0.0, 0.5, 0.0], createdAt: "2023-07-16/13:00:00", updatedAt: "2023-07-16/13:05:00"),
                   Tag(id: "3", name: "design", color: [0.0, 0.0, 1.0], createdAt: "2023-07-17/14:00:00", updatedAt: "2023-07-17/14:05:00"),
                   Tag(id: "4", name: "code", color: [0.5, 0.2, 0.7], createdAt: "2023-07-18/15:00:00", updatedAt: "2023-07-18/15:05:00"),
                   Tag(id: "5", name: "review", color: [0.8, 0.8, 0.0], createdAt: "2023-07-19/16:00:00", updatedAt: "2023-07-19/16:05:00"),
                   Tag(id: "6", name: "documentation", color: [0.0, 0.8, 0.8], createdAt: "2023-07-20/17:00:00", updatedAt: "2023-07-20/17:05:00"),
                   Tag(id: "7", name: "meeting", color: [0.8, 0.0, 0.8], createdAt: "2023-07-21/18:00:00", updatedAt: "2023-07-21/18:05:00"),
                   Tag(id: "8", name: "bugfix", color: [0.5, 0.5, 0.5], createdAt: "2023-07-22/19:00:00", updatedAt: "2023-07-22/19:05:00"),
                   Tag(id: "9", name: "feedback", color: [1.0, 0.5, 0.0], createdAt: "2023-07-23/20:00:00", updatedAt: "2023-07-23/20:05:00"),
                   Tag(id: "10", name: "hr", color: [0.6, 0.3, 0.0], createdAt: "2023-07-24/21:00:00", updatedAt: "2023-07-24/21:05:00"),
                   Tag(id: "11", name: "testing", color: [0.9, 0.9, 0.2], createdAt: "2023-07-25/22:00:00", updatedAt: "2023-07-25/22:05:00"),
                   Tag(id: "12", name: "seo", color: [0.0, 0.6, 0.6], createdAt: "2023-07-26/23:00:00", updatedAt: "2023-07-26/23:05:00"),
                   Tag(id: "13", name: "content", color: [0.4, 0.1, 0.5], createdAt: "2023-07-27/01:00:00", updatedAt: "2023-07-27/01:05:00"),
                   Tag(id: "14", name: "finance", color: [0.2, 0.5, 0.3], createdAt: "2023-07-28/02:00:00", updatedAt: "2023-07-28/02:05:00"),
                   Tag(id: "15", name: "maintenance", color: [0.7, 0.4, 0.1], createdAt: "2023-07-29/03:00:00", updatedAt: "2023-07-29/03:05:00"),
                   Tag(id: "16", name: "server", color: [0.2, 0.2, 0.2], createdAt: "2023-07-30/04:00:00", updatedAt: "2023-07-30/04:05:00"),
                   Tag(id: "17", name: "training", color: [0.5, 0.0, 0.5], createdAt: "2023-07-31/05:00:00", updatedAt: "2023-07-31/05:05:00"),
                   Tag(id: "18", name: "marketing", color: [0.5, 0.5, 0.0], createdAt: "2023-08-01/06:00:00", updatedAt: "2023-08-01/06:05:00"),
                   Tag(id: "19", name: "it", color: [0.0, 0.5, 0.5], createdAt: "2023-08-02/07:00:00", updatedAt: "2023-08-02/07:05:00")]*/
            
    func getRandomTags() -> [Tag] {
        let tagCount = Int.random(in: 1...5) // 1〜3個のタグを選ぶ
        return Array(Set((0..<tagCount).map { _ in allTags.randomElement()! })).sorted(by: { $0.id < $1.id })
    }
    
    func fetchAppData(){
        FirestoreManager.shared.fetchAppData { appData in
            guard let appData = appData else {
                print("Failed to fetch AppData")
                return
            }
            
            // 成功した場合の処理をここに書く
            print("Fetched AppData: \(appData)")
            
            // 例：username を表示
            print("Username: \(appData.username)")
        }
    }
    
    func setDummyData() -> AppData{
        return AppData(userid: "1", username: "Kinji", statuses: [
            Status(id: "1", name: "未着手", goals: [
                Goal(id: "1", name: "Goal 1", description: "", tasks: [], dueDate: "2023-09-20", isStarred: false, tags: getRandomTags(), thumbnail: "", createdAt: "", updatedAt: ""),
                Goal(id: "2", name: "Goal 2", description: "", tasks: [], dueDate: "2023-10-01", isStarred: true, tags: getRandomTags(), thumbnail: "", createdAt: "", updatedAt: "")
            ], updatedAt: ""),
            Status(id: "2", name: "対応中", goals: [
                Goal(id: "3", name: "Goal 3", description: "", tasks: [
                    
                    
                    TasQuestTask(id: "1", name: "Database Backup", description: "Backup the production database", dueDate: "2023-09-15", maxHealth: 2000, currentHealth: 1500, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-01", updatedAt: "2023-08-15"),
                    TasQuestTask(id: "2", name: "Design Mockup", description: "Create design mockup for landing page", dueDate: "2023-09-18", maxHealth: 1000, currentHealth: 500, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-05", updatedAt: "2023-08-20"),
                    TasQuestTask(id: "3", name: "Code Review", description: "Review team member's code", dueDate: "2023-09-10", maxHealth: 500, currentHealth: 200, tags: getRandomTags(), isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-02"),
                    TasQuestTask(id: "4", name: "Update Documentation", description: "Update API documentation", dueDate: "2023-09-22", maxHealth: 800, currentHealth: 400, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-25"),
                    TasQuestTask(id: "5", name: "Client Meeting", description: "Meeting with Client A for project update", dueDate: "2023-09-08", maxHealth: 300, currentHealth: 300, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-30", updatedAt: "2023-09-01"),
                    TasQuestTask(id: "6", name: "Bug Fix", description: "Fix login issue", dueDate: "2023-09-11", maxHealth: 900, currentHealth: 500, tags: getRandomTags(), isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-03"),
                    TasQuestTask(id: "7", name: "Customer Feedback", description: "Collect and analyze customer feedback", dueDate: "2023-09-20", maxHealth: 1200, currentHealth: 600, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-10", updatedAt: "2023-08-20"),
                    TasQuestTask(id: "8", name: "Team Onboarding", description: "Onboard new team members", dueDate: "2023-09-14", maxHealth: 400, currentHealth: 400, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-16"),
                    TasQuestTask(id: "9", name: "Performance Testing", description: "Conduct performance testing on new features", dueDate: "2023-09-19", maxHealth: 1000, currentHealth: 600, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-20", updatedAt: "2023-08-22"),
                    TasQuestTask(id: "10", name: "SEO Optimization", description: "Optimize website for search engines", dueDate: "2023-09-21", maxHealth: 700, currentHealth: 400, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-25", updatedAt: "2023-08-28"),
                    TasQuestTask(id: "11", name: "Content Creation", description: "Create blog posts for September", dueDate: "2023-09-30", maxHealth: 1100, currentHealth: 700, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-01", updatedAt: "2023-08-15"),
                    TasQuestTask(id: "12", name: "Budget Review", description: "Review and update Q4 budget", dueDate: "2023-09-25", maxHealth: 500, currentHealth: 300, tags: getRandomTags(), isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-04"),
                    TasQuestTask(id: "13", name: "Network Maintenance", description: "Check and maintain network hardware", dueDate: "2023-09-13", maxHealth: 600, currentHealth: 300, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-16"),
                    TasQuestTask(id: "14", name: "Server Cleanup", description: "Cleanup disk space on servers", dueDate: "2023-09-15", maxHealth: 800, currentHealth: 400, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-20", updatedAt: "2023-08-22"),
                    TasQuestTask(id: "15", name: "Product Training", description: "Train team on new product features", dueDate: "2023-09-09", maxHealth: 300, currentHealth: 300, tags: getRandomTags(), isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-02"),
                    TasQuestTask(id: "16", name: "Social Media Campaign", description: "Plan and execute social media campaign", dueDate: "2023-09-28", maxHealth: 1000, currentHealth: 600, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-10", updatedAt: "2023-08-12"),
                    TasQuestTask(id: "17", name: "Recruitment", description: "Conduct interviews for developer position", dueDate: "2023-09-07", maxHealth: 500, currentHealth: 250, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-25", updatedAt: "2023-08-26"),
                    TasQuestTask(id: "18", name: "Employee Review", description: "Conduct monthly employee performance review", dueDate: "2023-09-16", maxHealth: 700, currentHealth: 350, tags: getRandomTags(), isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-18"),
                    TasQuestTask(id: "19", name: "Software Update", description: "Update software on workstations", dueDate: "2023-09-12", maxHealth: 600, currentHealth: 300, tags: getRandomTags(), isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-03"),
                
                 
            ], dueDate: "2023-09-22", isStarred: false, tags: getRandomTags(), thumbnail: "", createdAt: "", updatedAt: "")
            ], updatedAt: ""),
            Status(id: "3", name: "完了", goals: [
                Goal(id: "4", name: "Goal 4", description: "", tasks: [], dueDate: "2023-09-19", isStarred: true, tags: getRandomTags(), thumbnail: "", createdAt: "", updatedAt: "")
            ], updatedAt: "")
        ], tags: allTags)
    }
     */
    
    func backgroundColor(for index: Int) -> Color {
        switch index {
        case 0: return Color(red: (255-30)/255, green: (226-30)/255, blue: (221-30)/255).opacity(1) // 赤寄りのピンク、少し濃い
        case 1: return Color(red: (253-30)/255, green: (236-30)/255, blue: (200-30)/255).opacity(1) // 黄色よりのオレンジ、少し濃い
        case 2: return Color(red: (219-30)/255, green: (237-30)/255, blue: (219-30)/255).opacity(1)
        default: return Color.gray
        }
    }

    func toggleStar(forGoalWithID goalID: String) {
        if let statusIndex = user.statuses.firstIndex(where: { status in
            status.goals.contains { $0.id == goalID }
        }), let goalIndex = user.statuses[statusIndex].goals.firstIndex(where: { $0.id == goalID }) {
            user.statuses[statusIndex].goals[goalIndex].isStarred.toggle()
        }
    }
}
