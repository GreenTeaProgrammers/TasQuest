//
//  ContentView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let sampleGoal = Goal(
            id: 1,
            name: "Sample Goal",
            description: "",
            tasks: [
                Task(id: 1, name: "Task 1", description: "", dueDate: "2023-09-30", maxHealth: 0, currentHealth: 0, tags: [], isVisible: true, createdAt: "", updatedAt: ""),
                Task(id: 2, name: "Task 2", description: "", dueDate: "2023-10-05", maxHealth: 0, currentHealth: 0, tags: [], isVisible: true, createdAt: "", updatedAt: "")
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
