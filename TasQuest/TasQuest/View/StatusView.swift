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
    
    var body: some View {
        NavigationStack {
            VStack {
                // ウェルカムメッセージと設定ボタン
                HStack {

                    Text("ようこそ \(viewModel.appData.username)")
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
                        TagView(appData: $viewModel.appData)  // TagViewを表示する。TagViewの定義が必要。
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
                    // ForEach で配列のインデックスを逆順にする
                    ForEach(viewModel.appData.statuses.indices.reversed(), id: \.self) { index in
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
                            // IDに基づいてStatus配列を降順にソート
                            viewModel.appData.statuses.sort { (status1, status2) in
                                if let id1 = Int(status1.id), let id2 = Int(status2.id) {
                                    return id1 > id2
                                }
                                return false
                            }
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
    
    @State private var showGoalDetailPopup: Bool = false  // ゴールの詳細情報ポップアップを表示するための状態変数
    @State private var navigateToTaskView: Bool = false  // TaskViewへの遷移を制御するための状態変数
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        ZStack {
            NavigationLink("", destination: TaskView(appData: $appData, status: $status, goal: $goal), isActive: $navigateToTaskView)
                .opacity(0)  // NavigationLinkを透明にして隠す
            
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
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.bottom, 8)
            .onTapGesture {
                self.navigateToTaskView = true  // タップでTaskViewに遷移
            }
            .gesture(
                LongPressGesture()
                    .onEnded { _ in
                        // 触覚フィードバックを生成
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                        
                        self.showGoalDetailPopup = true  // 長押しが終了したらポップアップを表示
                        self.navigateToTaskView = false  // 長押しでTaskViewに遷移しないようにする
                    }
            )
            .sheet(isPresented: $showGoalDetailPopup) {
                GoalDetailPopupView(goal: $goal)  // ゴールの詳細情報を表示するビュー
            }
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
}

struct GoalDetailPopupView: View {
    @Binding var goal: Goal
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Text("ゴールの詳細")
                    .font(.headline)
                    .foregroundColor(Color.primary)
                Spacer()
                Button(action: {
                    // 編集ロジックをここに配置
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
