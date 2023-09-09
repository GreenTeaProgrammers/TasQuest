//
//  ContentView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//
/*
import SwiftUI

struct ContentView: View {
    var tags: [Tag] = [
        
        Tag(id: 1, name: "urgent", color: [1.0, 0.0, 0.0], createdAt: "2023-07-15/12:00:00", updatedAt: "2023-07-15/12:05:00"),
        Tag(id: 2, name: "database", color: [0.0, 0.5, 0.0], createdAt: "2023-07-16/13:00:00", updatedAt: "2023-07-16/13:05:00"),
        Tag(id: 3, name: "design", color: [0.0, 0.0, 1.0], createdAt: "2023-07-17/14:00:00", updatedAt: "2023-07-17/14:05:00"),
        Tag(id: 4, name: "code", color: [0.5, 0.2, 0.7], createdAt: "2023-07-18/15:00:00", updatedAt: "2023-07-18/15:05:00"),
        Tag(id: 5, name: "review", color: [0.8, 0.8, 0.0], createdAt: "2023-07-19/16:00:00", updatedAt: "2023-07-19/16:05:00"),
        Tag(id: 6, name: "documentation", color: [0.0, 0.8, 0.8], createdAt: "2023-07-20/17:00:00", updatedAt: "2023-07-20/17:05:00"),
        Tag(id: 7, name: "meeting", color: [0.8, 0.0, 0.8], createdAt: "2023-07-21/18:00:00", updatedAt: "2023-07-21/18:05:00"),
        Tag(id: 8, name: "bugfix", color: [0.5, 0.5, 0.5], createdAt: "2023-07-22/19:00:00", updatedAt: "2023-07-22/19:05:00"),
        Tag(id: 9, name: "feedback", color: [1.0, 0.5, 0.0], createdAt: "2023-07-23/20:00:00", updatedAt: "2023-07-23/20:05:00"),
        Tag(id: 10, name: "hr", color: [0.6, 0.3, 0.0], createdAt: "2023-07-24/21:00:00", updatedAt: "2023-07-24/21:05:00"),
        Tag(id: 11, name: "testing", color: [0.9, 0.9, 0.2], createdAt: "2023-07-25/22:00:00", updatedAt: "2023-07-25/22:05:00"),
        Tag(id: 12, name: "seo", color: [0.0, 0.6, 0.6], createdAt: "2023-07-26/23:00:00", updatedAt: "2023-07-26/23:05:00"),
        Tag(id: 13, name: "content", color: [0.4, 0.1, 0.5], createdAt: "2023-07-27/01:00:00", updatedAt: "2023-07-27/01:05:00"),
        Tag(id: 14, name: "finance", color: [0.2, 0.5, 0.3], createdAt: "2023-07-28/02:00:00", updatedAt: "2023-07-28/02:05:00"),
        Tag(id: 15, name: "maintenance", color: [0.7, 0.4, 0.1], createdAt: "2023-07-29/03:00:00", updatedAt: "2023-07-29/03:05:00"),
        Tag(id: 16, name: "server", color: [0.2, 0.2, 0.2], createdAt: "2023-07-30/04:00:00", updatedAt: "2023-07-30/04:05:00"),
        Tag(id: 17, name: "training", color: [0.5, 0.0, 0.5], createdAt: "2023-07-31/05:00:00", updatedAt: "2023-07-31/05:05:00"),
        Tag(id: 18, name: "marketing", color: [0.5, 0.5, 0.0], createdAt: "2023-08-01/06:00:00", updatedAt: "2023-08-01/06:05:00"),
        Tag(id: 19, name: "it", color: [0.0, 0.5, 0.5], createdAt: "2023-08-02/07:00:00", updatedAt: "2023-08-02/07:05:00")
    
    ]
    var body: some View {
        let sampleGoal = Goal(
            id: 1,
            name: "Sample Goal",
            description: "",
            tasks: [
                
                    
                    TasQuestTask(id: 1, name: "Database Backup", description: "Backup the production database", dueDate: "2023-09-15", maxHealth: 2000, currentHealth: 1500, tags: [tags[0], tags[1]], isVisible: true, createdAt: "2023-08-01", updatedAt: "2023-08-15"),
                    TasQuestTask(id: 2, name: "Design Mockup", description: "Create design mockup for landing page", dueDate: "2023-09-18", maxHealth: 1000, currentHealth: 500, tags: [tags[2]], isVisible: true, createdAt: "2023-08-05", updatedAt: "2023-08-20"),
                    TasQuestTask(id: 3, name: "Code Review", description: "Review team member's code", dueDate: "2023-09-10", maxHealth: 500, currentHealth: 200, tags: [tags[3], tags[4]], isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-02"),
                    TasQuestTask(id: 4, name: "Update Documentation", description: "Update API documentation", dueDate: "2023-09-22", maxHealth: 800, currentHealth: 400, tags: [tags[5]], isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-25"),
                    TasQuestTask(id: 5, name: "Client Meeting", description: "Meeting with Client A for project update", dueDate: "2023-09-08", maxHealth: 300, currentHealth: 300, tags: [tags[6]], isVisible: true, createdAt: "2023-08-30", updatedAt: "2023-09-01"),
                    TasQuestTask(id: 6, name: "Bug Fix", description: "Fix login issue", dueDate: "2023-09-11", maxHealth: 900, currentHealth: 500, tags: [tags[7]], isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-03"),
                    TasQuestTask(id: 7, name: "Customer Feedback", description: "Collect and analyze customer feedback", dueDate: "2023-09-20", maxHealth: 1200, currentHealth: 600, tags: [tags[8]], isVisible: true, createdAt: "2023-08-10", updatedAt: "2023-08-20"),
                    TasQuestTask(id: 8, name: "Team Onboarding", description: "Onboard new team members", dueDate: "2023-09-14", maxHealth: 400, currentHealth: 400, tags: [tags[9]], isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-16"),
                    TasQuestTask(id: 9, name: "Performance Testing", description: "Conduct performance testing on new features", dueDate: "2023-09-19", maxHealth: 1000, currentHealth: 600, tags: [tags[10]], isVisible: true, createdAt: "2023-08-20", updatedAt: "2023-08-22"),
                    TasQuestTask(id: 10, name: "SEO Optimization", description: "Optimize website for search engines", dueDate: "2023-09-21", maxHealth: 700, currentHealth: 400, tags: [tags[11]], isVisible: true, createdAt: "2023-08-25", updatedAt: "2023-08-28"),
                    TasQuestTask(id: 11, name: "Content Creation", description: "Create blog posts for September", dueDate: "2023-09-30", maxHealth: 1100, currentHealth: 700, tags: [tags[12]], isVisible: true, createdAt: "2023-08-01", updatedAt: "2023-08-15"),
                    TasQuestTask(id: 12, name: "Budget Review", description: "Review and update Q4 budget", dueDate: "2023-09-25", maxHealth: 500, currentHealth: 300, tags: [tags[13]], isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-04"),
                    TasQuestTask(id: 13, name: "Network Maintenance", description: "Check and maintain network hardware", dueDate: "2023-09-13", maxHealth: 600, currentHealth: 300, tags: [tags[14]], isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-16"),
                    TasQuestTask(id: 14, name: "Server Cleanup", description: "Cleanup disk space on servers", dueDate: "2023-09-15", maxHealth: 800, currentHealth: 400, tags: [tags[15]], isVisible: true, createdAt: "2023-08-20", updatedAt: "2023-08-22"),
                    TasQuestTask(id: 15, name: "Product Training", description: "Train team on new product features", dueDate: "2023-09-09", maxHealth: 300, currentHealth: 300, tags: [tags[16]], isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-02"),
                    TasQuestTask(id: 16, name: "Social Media Campaign", description: "Plan and execute social media campaign", dueDate: "2023-09-28", maxHealth: 1000, currentHealth: 600, tags: [tags[17]], isVisible: true, createdAt: "2023-08-10", updatedAt: "2023-08-12"),
                    TasQuestTask(id: 17, name: "Recruitment", description: "Conduct interviews for developer position", dueDate: "2023-09-07", maxHealth: 500, currentHealth: 250, tags: [tags[9], tags[18]], isVisible: true, createdAt: "2023-08-25", updatedAt: "2023-08-26"),
                    TasQuestTask(id: 18, name: "Employee Review", description: "Conduct monthly employee performance review", dueDate: "2023-09-16", maxHealth: 700, currentHealth: 350, tags: [tags[9], tags[18]], isVisible: true, createdAt: "2023-08-15", updatedAt: "2023-08-18"),
                    TasQuestTask(id: 19, name: "Software Update", description: "Update software on workstations", dueDate: "2023-09-12", maxHealth: 600, currentHealth: 300, tags: [tags[14]], isVisible: true, createdAt: "2023-09-01", updatedAt: "2023-09-03"),
                
                 
            ],
            currentTaskIndex: 0,
            dueDate: "2023-12-31",
            isStarred: false,
            tags: [],
            thumbnail: "",
            createdAt: "",
            updatedAt: ""
        )
        
        TaskView(goal: sampleGoal)
    }
}
*/
