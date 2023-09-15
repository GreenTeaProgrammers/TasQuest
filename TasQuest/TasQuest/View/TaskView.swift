//
//  TaskView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//


import SwiftUI

struct TaskView: View {
    @State var statusIndex: Int
    @State var goalIndex: Int
    
    @State private var reloadFlag = false  // 追加
    
    @State private var showingUnityView = false  // Unityビュー表示フラグ

    @State var showingManageTaskModal = false  // ハーフモーダルの表示状態を管理
    
    
    var body: some View {
        let goal: Goal = AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex]
        
        ZStack {
            let taskCount = goal.tasks.filter { $0.isVisible }.count
            
            let height = max(0, (87.95) * CGFloat(taskCount - 1))
            VStack {
                HeaderView(statusIndex: statusIndex, goalIndex: goalIndex)
                
                Rectangle()
                    .fill(Color.gray)  // 色を設定
                    .frame(height: 2)  // 厚みを設定
                
                ScrollView {
                    ZStack(alignment: .leading) {
                        VStack {
                            Rectangle()
                                .fill(Color.black)
                            .frame(width: 5, height: height)
                        }
                        .padding(.leading, 9)
                        
                        
                        ScrollView{
                            TaskListView(statusIndex: statusIndex, goalIndex: goalIndex)
                        }
                    }
                }
                NavigationLink("", destination: UnityHostingController(), isActive: $showingUnityView).hidden()
            }
            .padding()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        showingManageTaskModal.toggle()  // ハーフモーダルを表示

                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 55, height: 55)
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            )
                    }.sheet(isPresented: $showingManageTaskModal) {
                        ManageTaskView(statusIndex: statusIndex, goalIndex: goalIndex)  // ハーフモーダルの内容
                    }
                    
                    
                    Button(action: {
                        showingUnityView.toggle()
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 55, height: 55)
                            .overlay(
                                Image(systemName: "gamecontroller")
                                    .resizable()
                                    .frame(width: 35, height: 20)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Button(action: {
                        // Trash
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 55, height: 55)
                            .overlay(
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.bottom, 60)
                .padding(.trailing, 16)
            }
        }
        .id(reloadFlag)  // 追加
        .onReceive(
            NotificationCenter.default.publisher(for: Notification.Name("TaskUpdated")),
            perform: { _ in
                self.reloadFlag.toggle()
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

struct HeaderView: View {
    @State var statusIndex: Int
    @State var goalIndex: Int
    
    @Environment(\.presentationMode) var presentationMode
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        var goal = AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex]
        VStack{
            ZStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    Text(goal.name)
                        .font(.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Button(action: {
                        goal.isStarred.toggle()  // @Bindingを通してgoalの状態を変更
                    }) {
                        Image(systemName: goal.isStarred ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(goal.isStarred ? .yellow : .gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
                .padding(.leading)
            }
            .padding(.top)
        }
        Text(dateFormatter.string(from: goal.dueDate))
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

struct TaskListView: View {
    @State var statusIndex: Int
    @State var goalIndex: Int
    
    var body: some View {
        let goal: Goal = AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex]
        ForEach(goal.tasks.indices, id: \.self) { index in
            if goal.tasks[index].isVisible {
                TaskRow(statusIndex: statusIndex, goalIndex: goalIndex, taskIndex: index)
            }
        }
        .onAppear {
            print("Current tasks: \(goal.tasks)")
        }
    }
}

struct TaskRow: View {
    @State var statusIndex: Int
    @State var goalIndex: Int
    @State var taskIndex: Int
    
    
    var body: some View {
        let task: TasQuestTask = AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].tasks[taskIndex]
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter
        }()
        
        // Calculate the fill color based on the task's current and max health
        var fillColor: Color {
            let percentage = task.currentHealth / task.maxHealth
            if percentage > 0.5 {
                return .green
            } else if percentage > 0.2 {
                return .yellow
            } else {
                return .red
            }
        }
        
        HStack {
            // Circle icon
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
            
            Button(action: {
                print("Task \(task.id) was clicked")
            }) {
                // Task name and tags
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.body)
                        .foregroundColor(.black)
                    
                    HStack {
                        ForEach(task.tags.prefix(3).indices, id: \.self) { tagIndex in
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        Color(
                                            red: Double(task.tags[tagIndex].color[0]),
                                            green: Double(task.tags[tagIndex].color[1]),
                                            blue: Double(task.tags[tagIndex].color[2])
                                        ).opacity(0.2)
                                    )
                                let truncatedTag = String(task.tags[tagIndex].name.prefix(5))
                                let displayTag = task.tags[tagIndex].name.count > 5 ? "\(truncatedTag)..." : truncatedTag
                                Text(displayTag)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 4)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .fixedSize()
                            .padding(.vertical, 2)
                        }
                    }
                    // 修正された部分
                    Text(dateFormatter.string(from: task.dueDate))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Health bar
                VStack {
                    let percentage: Float = task.maxHealth == 0 ? 0 : task.currentHealth / task.maxHealth
                    
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 150, height: 8)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(fillColor)
                                .frame(width: 150 * CGFloat(percentage))
                        }
                        .cornerRadius(4)
                    
                    Text("\(Int(task.currentHealth))/\(Int(task.maxHealth))")
                        .font(.footnote.bold())
                        .kerning(2)
                        .padding(.bottom, 24)
                }
            }
        }
        .frame(height: 80)
        .background(Color.clear)
        .onAppear(){
            print("Rendering task with ID: \(task.id)")
            
        }
        
    }
}
