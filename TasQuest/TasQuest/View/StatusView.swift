//
//  StatusView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//


import SwiftUI

struct StatusView: View {
    @State private var isNotAuthed: Bool = false
    @State private var showSettingView: Bool = false
    
    @State private var showTagView: Bool = false  // 新しく追加
    
    @State private var isAuthed: Bool = false
    
    @State private var showCreateGoalView: Bool = false  // 新しいゴール作成用モーダルを表示するための状態変数
    
    @StateObject private var viewModel = StatusViewModel()

    @State private var reloadFlag = false // 追加
    
    var body: some View {
        NavigationStack {
            VStack {
                // ウェルカムメッセージと設定ボタン
                HStack {
                    
                    Text("ようこそ \(AppDataSingleton.shared.appData.username)")
                        .font(.headline)
                    
                    Spacer()
                    
                    // 新しく追加: タグボタン
                    Button(action: {
                        showTagView = true
                    }) {
                        Image(systemName: "tag")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }.sheet(isPresented: $showTagView) {
                        //TagView(appData: $viewModel.appData)  //Todo: TagViewを表示する。TagViewの定義が必要。
                    }
                    
                    Button(action: {
                        showSettingView = true
                    }) {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }.sheet(isPresented: $showSettingView) {
                        SettingView(showSignInView: $isNotAuthed)
                    }
                }
                .padding()
                
                // ステータスとその目標を表示
                ScrollView {
                    ForEach(AppDataSingleton.shared.appData.statuses.indices.reversed(), id: \.self) { index in
                        StatusRow(statusIndex: index)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(viewModel.backgroundColor(for: index))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            .padding(.bottom, 8)
                    }
                }
            }
            .fullScreenCover(isPresented: $isNotAuthed) {
                WelcomeView(isNotAuthed: $isNotAuthed)
            }
            .onAppear() {
                do {
                    let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
                    self.isNotAuthed = authUser == nil
                    self.isAuthed = authUser != nil  // 認証状態を更新
                    viewModel.fetchAppData { fetchedAppData in
                        if let fetchedAppData = fetchedAppData {
                            AppDataSingleton.shared.appData = fetchedAppData
                            NotificationCenter.default.post(name: Notification.Name("StatusUpdated"), object: nil)//強制的に全体を再レンダリング
                        } else {
                            // Handle the error case here
                        }
                    }
                } catch {
                    print("Error fetching authenticated user: \(error)")
                }
            }
            Spacer()
        }
        .id(reloadFlag)  // 追加
        .onReceive(
            NotificationCenter.default.publisher(for: Notification.Name("StatusUpdated")),
            perform: { _ in
                self.reloadFlag.toggle()
            }
        )
    }
}

struct StatusRow: View {
    @State var statusIndex: Int
    
    @State private var showCreateGoalView: Bool = false  // 新しいゴール作成用モーダルを表示するための状態変数

    var body: some View {
        let status: Status = AppDataSingleton.shared.appData.statuses[statusIndex]
        VStack {
            HStack {
                Text(status.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                
                // 新しいゴール作成ボタン
                Button(action: {
                    showCreateGoalView = true
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .sheet(isPresented: $showCreateGoalView) {
                    // ここでCreateGoalHalfModalViewを呼び出す
                    CreateGoalHalfModalView(statusIndex: statusIndex)
                }
            }
            .padding(.top)
            
            if status.goals.isEmpty {
                HStack {
                    Spacer()
                    Text("ゴールがありません")
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ForEach(status.goals.indices, id: \.self) { index in
                    GoalRow(statusIndex: statusIndex, goalIndex: index)
                }
            }
        }
    }
}

struct GoalRow: View {
    @State var statusIndex: Int
    @State var goalIndex: Int
    
    let viewModel:StatusViewModel = StatusViewModel()
    
    let hostModel = HostModel() // これを追加

    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        let goal = AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex]
        
        NavigationLink(destination: TaskView(statusIndex: statusIndex, goalIndex: goalIndex)) {
            HStack {
                Text(goal.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .bold()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(dateFormatter.string(from: goal.dueDate))
                            .foregroundColor(.gray)
                        HStack {
                            // タグが存在する場合はそのタグを表示
                            ForEach(goal.tags.prefix(3).indices, id: \.self) { tagIndex in
                                displayTag(tag: goal.tags[tagIndex])
                            }
                            
                            // タグが存在しない場合は透明なダミータグを表示
                            if goal.tags.isEmpty {
                                displayTag(tag: nil)
                            }
                        }
                    }
                    Spacer()
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleStar(forGoalWithID: goal.id)
                }) {
                    Image(systemName: goal.isStarred ? "star.fill" : "star")
                        .foregroundColor(goal.isStarred ? .yellow : .gray)
                }
            }
            .onTapGesture{
                hostModel.sendStatusIDToUnity(statusID: AppDataSingleton.shared.appData.statuses[statusIndex].id)
                hostModel.sendGoalIDToUnity(goalID: goal.id)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.bottom, 8)
    }
}

func displayTag(tag: Tag?) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                tag != nil ?
                Color(
                    red: Double(tag!.color[0]),
                    green: Double(tag!.color[1]),
                    blue: Double(tag!.color[2])
                ).opacity(0.2) : Color.clear
            )
        if let actualTag = tag {
            let truncatedTag = String(actualTag.name.prefix(8))
            let displayTag = actualTag.name.count > 8 ? "\(truncatedTag)..." : truncatedTag
            Text(displayTag)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
    .fixedSize()
    .padding(.vertical, 2)
}
