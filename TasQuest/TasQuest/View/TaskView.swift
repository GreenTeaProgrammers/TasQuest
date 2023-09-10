//
//  TaskView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//


import SwiftUI

struct TaskView: View {
    @State var appData: AppData
    @State var goal: Goal
    @State var showingCreateTaskModal = false  // ハーフモーダルの表示状態を管理
    
    
    var body: some View {
        ZStack {
            let taskCount = goal.tasks.filter { $0.isVisible }.count
            let height = max(0, (87.95) * CGFloat(taskCount - 1))
            VStack {
                HeaderView(goal: $goal)
                
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
                            TaskListView(goal: goal)
                        }
                    }
                }
                
            }
            .padding()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        showingCreateTaskModal.toggle()  // ハーフモーダルを表示

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
                    }.sheet(isPresented: $showingCreateTaskModal) {
                        CreateTaskHalfModalView(appData: $appData)  // ハーフモーダルの内容
                    }
                    
                    
                    Button(action: {
                        // Game View
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
        .navigationBarBackButtonHidden(true)
    }
}

struct HeaderView: View {
    @Binding var goal: Goal  // @Stateを@Bindingに変更
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TaskViewModel  // ViewModelのインスタンスを追加
    
    init(goal: Binding<Goal>) {
        self._goal = goal
        self.viewModel = TaskViewModel(goal: goal.wrappedValue)
    }
    
    var body: some View {
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
        Text(goal.dueDate)
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

struct TaskListView: View {
    var goal: Goal
    
    var body: some View {
        ForEach(goal.tasks.indices, id: \.self) { index in
            if goal.tasks[index].isVisible {
                TaskRow(task: goal.tasks[index])
            }
        }
    }
}

struct TaskRow: View {
    var task: TasQuestTask
    
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
    
    var body: some View {
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
                    Text(task.dueDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Health bar
                VStack {
                    let percentage = task.currentHealth / task.maxHealth
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
    }
}

