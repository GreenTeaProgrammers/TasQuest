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
                        TagView()
                    }
                    .padding()
                    
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
            // タイトル部分
            HStack {
                Text(status.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.top)
            
            // ゴールリスト
            ForEach(status.goals.indices, id: \.self) { index in
                GoalRow(statusIndex: statusIndex, goalIndex: index)
            }
            
            // 新しいゴール作成ボタン
            Button(action: {
                showCreateGoalView = true
            }) {
                HStack{
                    Spacer()
                    Text("+ ゴールを追加")
                        .font(.callout)
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    Spacer()
                }
                .background(Color.gray.opacity(0.5))
                .cornerRadius(8)
                .sheet(isPresented: $showCreateGoalView) {
                    // ここでCreateGoalHalfModalViewを呼び出す
                    ManageGoalView(statusIndex: statusIndex)
                }
            }
            .padding(.top, 8)
        }
    }
}

struct GoalRow: View {
    @State var statusIndex: Int
    @State var goalIndex: Int

    let viewModel: StatusViewModel = StatusViewModel()
    let hostModel = HostModel()
    
    @State private var showGoalDetailPopup: Bool = false
    @State private var navigateToTaskView: Bool = false

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

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

    var body: some View {
        let goal = AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex]

        ZStack {
            NavigationLink("", destination: TaskView(statusIndex: statusIndex, goalIndex: goalIndex), isActive: $navigateToTaskView)
                .opacity(0)

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
                            ForEach(goal.tags.prefix(3).indices, id: \.self) { tagIndex in
                                displayTag(tag: goal.tags[tagIndex])
                            }

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
            .onTapGesture {
                hostModel.sendStatusIDToUnity(statusID: AppDataSingleton.shared.appData.statuses[statusIndex].id)
                hostModel.sendGoalIDToUnity(goalID: goal.id)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.bottom, 8)
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        self.navigateToTaskView = true
                    }
            )
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                        self.showGoalDetailPopup = true
                        self.navigateToTaskView = false
                    }
            )
            .sheet(isPresented: $showGoalDetailPopup) {
                GoalDetailPopupView(statusIndex: statusIndex, goalIndex: goalIndex)
            }
        }
    }
}


struct GoalDetailPopupView: View {
    @State var statusIndex: Int
    @State var goalIndex: Int

    @State private var showManageGoalView: Bool = false  // 追加
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        let goal: Goal = AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex]
        VStack {
            HStack {
                Text("ゴールの詳細")
                    .font(.headline)
                    .foregroundColor(Color.primary)
                Spacer()
                Button(action: {
                    self.showManageGoalView = true  // 編集ビューを表示
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color.blue)
                        .padding(10)
                        .background(Circle().fill(Color.blue.opacity(0.1)))
                }
            }
            .padding()
            
            Divider()
                .background(Color.gray)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("名前: \(goal.name)")
                    .fontWeight(.medium)
                
                Text("説明: \(goal.description)")
                    .font(.caption)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.gray)
                    Text("期日: \(goal.dueDate, formatter: dateFormatter)")
                }
                
                HStack {
                    Image(systemName: "tag")
                        .foregroundColor(Color.gray)
                    Text("タグ: \(goal.tags.map { $0.name }.joined(separator: ", "))")
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(Color.gray)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(goal.tags, id: \.name) { tag in
                                    displayTag(tag: tag)
                                        .padding(4)
                                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.2)))
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(Color.gray)
                    Text("作成日時: \(goal.createdAt, formatter: dateFormatter)")
                }
                
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(Color.gray)
                    Text("更新日: \(goal.updatedAt, formatter: dateFormatter)")
                }
            }
            .padding()
            .sheet(isPresented: $showManageGoalView) {
                ManageGoalView(statusIndex: statusIndex,editingGoal: goal)  // ゴールを編集するビュー
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 5)
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
}
