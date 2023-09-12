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
    @State private var isAuthed: Bool = false
    
    @State private var showCreateGoalView: Bool = false  // 新しいゴール作成用モーダルを表示するための状態変数
    
    @StateObject private var viewModel = StatusViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // ウェルカムメッセージと設定ボタン
                HStack {
                    Text("ようこそ \(viewModel.appData.username)")
                        .font(.headline)
                    Spacer()
                    
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
                    ForEach(viewModel.appData.statuses.indices, id: \.self) { index in
                        StatusRow(viewModel: viewModel, appData: $viewModel.appData, status: $viewModel.appData.statuses[index])
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
                WelcomeView(isNotAuthed: $isNotAuthed, appData: $viewModel.appData)
            }
            .onAppear() {
                do {
                    let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
                    self.isNotAuthed = authUser == nil
                    self.isAuthed = authUser != nil  // 認証状態を更新
                    viewModel.fetchAppData { fetchedAppData in
                        if let fetchedAppData = fetchedAppData {
                            viewModel.appData = fetchedAppData
                            // Do any additional work here
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
    }
}

struct StatusRow: View {
    @ObservedObject var viewModel: StatusViewModel
    @Binding var appData: AppData
    @Binding var status: Status
    
    @State private var showCreateGoalView: Bool = false  // 新しいゴール作成用モーダルを表示するための状態変数

    var body: some View {
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
                    CreateGoalHalfModalView(appData: $appData, status: $status)
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
                    GoalRow(viewModel: viewModel, appData: $appData, status: $status, goal: $status.goals[index])
                }
            }
        }
    }
}

struct GoalRow: View {
    @ObservedObject var viewModel: StatusViewModel
    @Binding var appData: AppData
    @Binding var status: Status
    @Binding var goal: Goal
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        NavigationLink(destination: TaskView(appData: $appData, status: $status, goal: $goal)) {
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
